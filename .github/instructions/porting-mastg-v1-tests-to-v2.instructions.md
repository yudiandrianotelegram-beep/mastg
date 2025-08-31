# Porting MASTG v1 Tests to v2

### Writing content

Check some of the current tests and take them as reference

* tests-beta
* demos

Always take the most recent tests (the ones with the highest IDs) as reference/template.

Also review these. We’ll be using them and creating new ones as well:

* [https://mas.owasp.org/MASTG/techniques/](https://mas.owasp.org/MASTG/techniques/)
* [https://mas.owasp.org/MASTG/tools/](https://mas.owasp.org/MASTG/tools/) 

#### Guidelines

* How to write new **tests**: [Writing MAS Weaknesses & Tests](https://docs.google.com/document/d/1EMsVdfrDBAu0gmjWAUEs60q-fWaOmDB5oecY9d9pOlg/edit?pli=1&tab=t.0#heading=h.j1tiymiuocrm)
* How to write **demos**: [Writing MAS Weaknesses & Tests](https://docs.google.com/document/d/1EMsVdfrDBAu0gmjWAUEs60q-fWaOmDB5oecY9d9pOlg/edit?pli=1&tab=t.0#heading=h.y294y561hx14) 

**Important** tips and guidelines: 

1. Create a rough draft.
   1. In most cases you’ll have something in the v1 test
   2. Sometimes you can take the whole test or just a sentence or bullet point.
   3. You may use [chatGPT](https://chat.openai.com/) to create an initial draft and massage the content.
2. Edit it yourself using **your knowledge**
3. **Always include inline references** e.g. to
   1. MASTG chapters
   2. APIs
   3. statements in the dev docs
4. Before pushing, use [deepl write](https://www.deepl.com/en/write) to correct any mistakes and tweak phrasing (especially if you used chatGPT, use deepl to humanize the text)

**About the IDs:**

* Turn MASTG-TEST-0017 \-\> MASTG-TEST-0x17
* If you need to split then do like MASTG-TEST-0x17-1, MASTG-TEST-0x17-2, MASTG-TEST-0x17-3 …
* We’ll take care of fixing the IDs before merging.

**Language**: use simple language, be concise and clear

- Avoid passive voice
- Avoid long and complex sentences
  - **bad** "In order to encrypt data, Android offers the following Android APIs".
  - **good**: "You can use these APIs to encrypt data."
- See [Style Guide \- OWASP Mobile Application Security](https://mas.owasp.org/contributing/5_Style_Guide/) 

#### List of sources

Use the MASTG first, e.g. the guides for 0x04 (general), 0x05 (Android) and 0x06 (iOS) and **extend** with android/apple docs.

**Android** 

- [https://developer.android.com/privacy-and-security/security-tips](https://developer.android.com/privacy-and-security/security-tips)
- [https://developer.android.com/privacy-and-security/security-best-practices](https://developer.android.com/privacy-and-security/security-best-practices)
- [https://developer.android.com/privacy-and-security/risks](https://developer.android.com/privacy-and-security/risks) (these have special treatment in the metadata)
- [https://developer.android.com/privacy-and-security/about](https://developer.android.com/privacy-and-security/about)
- [https://developer.android.com/docs/quality-guidelines/core-app-quality\#sc](https://developer.android.com/docs/quality-guidelines/core-app-quality#sc)

**iOS**

- [https://developer.apple.com/app-store/user-privacy-and-data-use/](https://developer.apple.com/app-store/user-privacy-and-data-use/) 

## Porting tests to V2

Map to MASWE. You can check the new MASWE by searching for the old test ID in the **weaknesses/** directory. For example MASTG-TEST-0017.

Create a branch for the ticket: port-MASTG-TEST-0017

If the “MASVS” folder does not exist yet, create it.

Name the new file MASTG-TEST-0x17.md \-\> We’ll use the x to avoid ID collision and we’ll rename them later.

* Turn MASTG-TEST-0017 \-\> MASTG-TEST-0x17
* If you need to split then do like MASTG-TEST-0x17-1, MASTG-TEST-0x17-2, MASTG-TEST-0x17-3 …

One test in V1 may be turned into one or multiple tests in v2. Sometimes you'll find one sentence and that can be converted into a new test.

Search for references in the current **Document/**

And add them as 

`["Confirm Credential Flow"](../../../Document/0x05f-Testing-Local-Authentication.md#confirm-credential-flow)`

We don’t want to duplicate information. You may summarize part of the other section but what’s important is to explain what can go wrong with that feature or API. That may be explained in the referenced section or not but it must be in the test because that’s gonna be what we’re going to test for.

The thing we’re testing for must also have a very specific mitigation.

Part of the test not relevant? Remove and add a note in the ticket.

**Example:** In MASTG-TEST-0017, what’s written in dynamic analysis does not make sense: why should we validate that setUserAuthenticationValidityDurationSeconds are for real (we are not testing if Android features work; we assume they do). Maybe we could also use dynamic analysis but following a different approach. 

Add missing links to docs. 

**Example:** this test and the referenced section both were missing links to [https://developer.android.com/](https://developer.android.com/) 

## Important to consider when working on a test

V1 tests may include **techniques**, **tools** and even theory. Move that Info to the right place or create it and use references. e.g. @MASTG-TECH-0002

Theory must be always linked to the 0x04/5/6 chapters.

Review existing content and **UPDATE** it. Especially references to Android/iOS versions and things you know have changed since the text was written.

#### Add Best Practices

Best practices are platform specific and can be linked in the test metadata. Our automation creates a “Mitigations” section automatically.

1. Check if a best practice already exists in `best-practices/` folder
2. If it doesn’t exist yet, create it new in `best-practices/` using the next available ID
3. Add a reference to the best practices with @MASTG-BEST-xxxx

#### Deprecating V1 tests

Add metadata:

`"status: deprecated"`
`"covered_by: [MASTG-TEST-02xx]" (leave empty if no coverage)`
`deprecation_note: "New version available in MASTG V2"`
If the test isn’t covered in MASVS v2, enter the reason why.

If you don't know, open a ticket "Add Deprecation Note for MASTG-TEST-01xx".

### Threat based

Some things we're testing are only an issue if you consider an attacker with root access (typically L2 weaknesses). Double check that the conditions of the test matches the profile of the associated MASWE. IF THERE'S A MISMATCH WE MAY CREATE A SEPARATE MASWE FOR IT BECAUSE IT REPRESENTS A DIFFERENT RISK.

[https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0010/\#dynamic-analysis](https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0010/#dynamic-analysis)

Pay special attention to things like this. Indicate if the thing you're testing for requires root to be exploited or not.

*On devices supporting file-based encryption (FBE) ↗, snapshots are stored in the /data/system\_ce/\<USER\_ID\>/\<IMAGE\_FOLDER\_NAME\> folder. \<IMAGE\_FOLDER\_NAME\> depends on the vendor but most common names are snapshots and recent\_images. If the device doesn't support FBE, the /data/system/\<IMAGE\_FOLDER\_NAME\> folder is used.*

Accessing these folders and the snapshots requires root.

EXAMPLE: cleartext configured globally in NSC. No need for root, network/mitm: yes

What other things to consider here?

- **binary**: possible just because the attacker has the binary (decrypted on iOS)
- **app**: another app on the device with the right permissions (e.g. full access to external storage)
- **mitm**: a network based attacker capable of performing MITM
- **user computer**: the user using adb
- **user UI**: using the app's or another app’s UI, e.g. third party file manager;
- **user confirmation**: e.g. pasteboard confirmation

### Code Snippets

If the test has snippets, you can use them for the new demos. Rewrite any existing snippets and AVOID JAVA AND OBJECTIVE C.

You can create a demo **status: draft** and come back later to it. Just to ensure we extracted everything from V1. Create a ticket **"Finish Demo Draft MASTG-DEMO-xxxx"**

- [https://github.com/WithSecureLabs/sieve/](https://github.com/WithSecureLabs/sieve/)
- Ovaa
- MASTG playground
- [https://mas.owasp.org/MASTG/apps/](https://mas.owasp.org/MASTG/apps/) 

List of apps to get ideas from, as inspiration. You may include "inspired by" to ref to the original source whenever our new content is similar enough.

### NOTES

* platform: android, ios or network
*
* A test MUST NOT describe the general problem *again*. That’s the Weakness’ job. Focus on how that thing happens in Android / iOS and why it’s important to do this test.
* A test can be \[static, dynamic\] and the steps are describing both
  * Example: MASTG-TEST-0209
    * 1\. Run a static analysis tool such as @MASTG-TOOL-0073 on the app binary, or use a dynamic analysis tool like @MASTG-TOOL-0039, and look for uses of the cryptographic functions that generate keys.
  * The demos are going to be more specific and address static and dynamic separately
  * If you find an edge case, let’s discuss it.
    * e.g. just because *the way* something is tested it could deserve a separate test with its own distinct overview, steps, etc.

### OS version

**For Android:** We have agreed on supporting the **current version \- 5**. This gives a roughly 90% adoption rate on average. See [https://apilevels.com/](https://apilevels.com/) 

If a test is not applicable anymore in some OS versions we can create it with a note of the versions where it applies. This way if you're testing an app that has a minsdk greater than that, you can discard that test.

We will avoid creating demos for unsupported versions.

e.g. webviews file access or defaults depend on this.

```md
---
platform: android
title: Insecure Implementation of Confirm Credentials
id: MASTG-TEST-0x017
type: [static, dynamic]
available_since: 21
deprecated_since: 29
weakness: MASWE-0034
---
```