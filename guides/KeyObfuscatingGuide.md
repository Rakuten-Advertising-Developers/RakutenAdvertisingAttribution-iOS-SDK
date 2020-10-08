
## Private Key Obfuscation Guide

Private key obfuscation process avoids bundling the private key in the app executable file. Our attribution SDK provides Obfuscator helper struct to generate obfuscated key (RADAttributionKey).

Private key obfuscation process avoids bundling the private key in executable file and make it hard for someone looking for senstive information by opening up your app's executable file.

Example onetime Swift code to generate RADAttributionKey.
```swift
// secure your passphrase in case needed to regenerate obfuscated key
let obfuscator = Obfuscator(with: "<your passphrase>") 
// copy the rad_rsa_private.pem content into <YOUR_RSA_PRIVATE_KEY>
let bytes = obfuscator.obfuscatingBytes(from: "<YOUR_RSA_PRIVATE_KEY>")
// TODO: remove the above two lines after key generation.
```

Run the above code in DEBUG mode and check for the following message (sample) in the console log.

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
// TODO: remove the above two lines after key generation.
```

The above obfuscated RADAttributionKey is required during the attribution SDK initialization setup.  Optionally you can copy the above swift code printed from the console and copy as a new swift file (named SecretContants.swift).

```swift
let key = PrivateKey.data(value: obfuscator.revealData(from: SecretConstants().RADAttributionKey))
```
