## Frida Scripts

This guide defines how to write and use Frida scripts in MASTG demos. Scripts live alongside the demo content and are executed by `run.sh` to produce the demo’s Observation output.

Version requirement

- Use Frida 17 or later. See @MASTG-TOOL-0031 (Frida): https://mas.owasp.org/MASTG/tools/generic/MASTG-TOOL-0031/#frida-17

### Location and naming

- Place scripts inside the demo folder and name them `script.js` unless multiple scripts are needed.
- If multiple scripts are required, use specific names (for example, `hook_ssl.js`, `hook_keystore.js`) and document which to run in the demo Steps and `run.sh`.

Examples:

- `demos/ios/MASVS-AUTH/MASTG-DEMO-0042/script.js`
- `demos/android/MASVS-NETWORK/MASTG-DEMO-0007/script.js`

### Runtime and invocation

- Prefer the V8 runtime unless a different engine is necessary; you can enforce it with `--runtime=v8`.
- Typical spawn usage in `run.sh`:
	- `frida -U -f <bundle_or_package_id> -l script.js --no-pause --runtime=v8 > output.txt`
- Typical attach usage:
	- `frida -U -n <process-name> -l script.js --runtime=v8 > output.txt`

### Coding conventions

- Keep scripts self-contained (no external module imports).
- Keep output concise and deterministic for Evaluation parsing.
- Validate availability before hooking:
	- iOS: `if (ObjC.available) { ... }`
	- Android: `Java.perform(() => { ... })`
- Check class/method existence; log a clear message if missing.
- Avoid global side effects; scope variables within hooks/functions.
- Logging: prefer `console.log()`; add short section headers only when helpful.
- Backtraces: use `DebugSymbol.fromAddress` and cap lines.
- In `onEnter/onLeave`, capture context first (for example, `const ctx = this.context;`) before using nested arrow functions.

### iOS patterns

- Hook Objective-C methods with explicit `-` (instance) or `+` (class) signatures.
- Example (LAContext evaluatePolicy):

````javascript
if (ObjC.available && ObjC.classes.LAContext) {
	const method = ObjC.classes.LAContext["- evaluatePolicy:localizedReason:reply:"];
	if (method) {
		Interceptor.attach(method.implementation, {
			onEnter(args) {
				const ctx = this.context;
				const LAPolicy = { 1: ".deviceOwnerAuthenticationWithBiometrics", 2: ".deviceOwnerAuthentication" };
				const policy = args[2].toInt32();
				console.log(`LAContext.evaluatePolicy called with ${LAPolicy[policy] || "Unknown"} (${policy})`);
				const bt = Thread.backtrace(ctx, Backtracer.ACCURATE).slice(0, 8).map(DebugSymbol.fromAddress);
				console.log("Backtrace:\n" + bt.join("\n"));
			}
		});
	} else {
		console.log("LAContext.evaluatePolicy not found");
	}
} else {
	console.log("ObjC runtime not available or LAContext missing");
}
````

### Android patterns

- Wrap hooks in `Java.perform` and use `Java.use` to access classes.
- Example:

````javascript
Java.perform(() => {
	const HttpsURLConnection = Java.use('javax.net.ssl.HttpsURLConnection');
	HttpsURLConnection.setHostnameVerifier.overload('javax.net.ssl.HostnameVerifier').implementation = function (verifier) {
		console.log('HttpsURLConnection.setHostnameVerifier called');
		return this.setHostnameVerifier(verifier);
	};
});
````

### Logging and outputs

- Redirect script output to `output.txt` from `run.sh`.
- Keep logs minimal and structured so Observation/Evaluation can reference them directly.
- Cap list outputs (for example, backtraces) to keep diffs stable.

### Safety and troubleshooting

- Use try/catch around complex hooks to prevent script termination.
- If a symbol/method is missing, log and continue.
- Spawn vs attach: use `-f` for early instrumentation when needed.
- Consider stripped binaries and symbol resolution; prefer Objective-C/Java-level hooks over raw native symbols where possible.

### Cross-links

- Tools: @MASTG-TOOL-0031 (Frida)
- Techniques: @MASTG-TECH-0045 (Runtime Reverse Engineering), @MASTG-TECH-0015 / @MASTG-TECH-0067 (Dynamic Analysis)

### Alignment with Tools/Frida

- The authoritative reference for installing, configuring, and troubleshooting Frida lives under Tools: @MASTG-TOOL-0031. Do not duplicate setup steps in demos; instead, link to the Tools page.
- Version compatibility: ensure `frida-tools` (CLI on the host) and the device runtime (for example, `frida-server` on Android or injected runtime on iOS) use matching major/minor versions (17.x with 17.x).
- Device and transport flags: align with Tools documentation and prefer these consistently in `run.sh`:
	- `-U` USB default device
	- `-D <id>` a specific device by ID
	- `-H <host:port>` network/remote device (for example, when port-forwarding or remote frida-server)
- Platform notes (defer details to Tools page):
	- Android: frida-server typically runs on-device; you may use adb port-forwarding when targeting `-H`.
	- iOS: non-jailbroken workflows don’t need frida-server; rely on USB transport. Jailbroken workflows might use frida-server; follow the Tools guidance.
- Demo authors should: link to Tools for environment prep, keep `script.js` runtime-agnostic, and focus scripts on instrumentation logic, not environment management.