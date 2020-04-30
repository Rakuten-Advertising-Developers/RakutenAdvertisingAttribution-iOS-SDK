## Key Preparation Guide
We strongly not recommend keep your key as a file or as static sting in the project because of security reasons. Feel free to use your own secure approach if you want. Anyway as part of `RADAttribution` SDK provided `Obfuscator` struct, which gives ability obfuscate key. Follow to instructions bellow

1. Initialize `Obfuscator` struct instance passing some `salt` parameter (you can choose any string, actually)
```swift
let obfuscator = Obfuscator(with: Bundle.main.bundleIdentifier!)
```
2. Generate bytes array from your original key's string
```swift
let bytes = obfuscator.obfuscatingBytes(from: <YOUR_PRIVATE_KEY>)
```
In DEBUG mode you can check console log, where will be printed something similar to this
```
--------------------
Salt used: <YOUR_SALT_STRING>
--------------------
Swift code:

struct SecretConstants {

	let RADAttributionKey: [UInt8] = [78, 66, 64, 3, 95, 35, 46, 50, 61, 43, 78, 124, 50, 37, 86, 53, 32, 61, 63, 50, 61, 
...
	91, 48, 5, 27, 1, 9, 103, 11, 21, 5, 39, 5, 7, 84, 33, 30, 60, 73, 6, 47, 34, 32, 30, 92, 35, 66, 83, 49, 48, 60, 20, 36, 81, 11, 38, 32, 94, 22, 2, 10, 48, 25, 12, 69, 8, 48, 46, 47, 36, 15, 0, 83, 39, 104, 85, 76, 64, 93, 41, 43, 39, 79, 63, 125, 51, 65, 59, 39, 61, 51, 47, 122, 36, 68, 61, 32, 43, 89, 68, 94, 68, 67]
}
```
3. Create in your project a new .swift file and copy-paste swift code printed in console on the previous step. And yes, `let RADAttributionKey` can be really huge.
4. **Remove code, related to step 2 and all appearances of private key string in your code**. Then write the following code and rerun project
```swift
let privateKey = obfuscator.revealData(from: SecretConstants().RADAttributionKey)
//or
let privateKeyString = obfuscator.revealString(from: SecretConstants().RADAttributionKey)
```
> Make sure that `obfuscator` instance initialized by same salt parameter
5. Double-check that received generated private key is equal to the source file.
6. Continue RADAttribution setup with current generated privateKey
