e asm.bytes=false
e scr.color=false
e asm.var=false

?e Find 'isCaptured' function in the binary
iz~objc~isCaptured

?e

?e Print 'isCaptured' x-refs in the binary
axt 0x1000100b0

?e

?e Find 'sceneCaptureState' function in the binary
iz~objc~sceneCaptureState

?e

?e Print 'isCaptured' x-refs in the binary
axt 0x1000100c8
