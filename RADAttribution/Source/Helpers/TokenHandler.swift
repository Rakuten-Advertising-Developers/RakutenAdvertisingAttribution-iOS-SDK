//
//  TokenHandler.swift
//  RADAttribution
//
//  Created by Durbalo, Andrii on 27.04.2020.
//

import Foundation
import SwiftJWT

final class TokenHandler {
    
    struct RADClaims: Claims {
        let iss: String
        let sub: String
        let aud: String
        let kid: String
        let iat: Date
        let exp: Date
    }
    
    let tokenProvider: TokenProvider
    
    init(tokenProvider: TokenProvider, privateKey: String) {
        self.tokenProvider = tokenProvider
    }
    
    func from(key: String) {
        
        let myClaims = RADClaims(iss: "attribution-sdk",
                                 sub: "attribution-sdk",
                                 aud: "1",
                                 kid: "",
                                 iat: Date(timeIntervalSince1970: 1587514842),//Date(),
            exp: Date(timeIntervalSince1970: 1587694842))//Date(timeIntervalSinceNow: 60*60*24))
        
        //        {
        //          iss: 'attribution-sdk',
        //          sub: 'attribution-sdk',
        //          aud: '1',
        //          iat: 1587514842,
        //          exp: 1587694842,
        //        }
        
        var myJWT = JWT(claims: myClaims)
        let privateKey = pemString.data(using: .utf8)!
        let jwtSigner = JWTSigner.rs256(privateKey: privateKey)
        
        guard let signedJWT = try? myJWT.sign(using: jwtSigner) else { return }
        
        let publicKey = publicPemString.data(using: .utf8)!
        let jwtVerifier = JWTVerifier.rs256(publicKey: publicKey)
        
        let verified = JWT<RADClaims>.verify(signedJWT, using: jwtVerifier)
        
        print(signedJWT)
    }
}



  let pemString = """
-----BEGIN RSA PRIVATE KEY-----
        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
        -----END RSA PRIVATE KEY-----
"""

let pemString2 = """
-----BEGIN RSA PRIVATE KEY-----
MIIJKAIBAAKCAgEAv2GQxmAu8igZje44TGiRm8sWhiot5SWy3JphXoAHX7GmCivf
42V9l4tKei+k7Ka0OJ96L9Suv0zokzRlwe8YNuHOFQQUv5QbxJHhqOyRnITS+GVo
nXBvFGR4MlPc75FNDN2OvIfHMBkbaervCEzuJFVB71cP+LelyoVF5AheBKLxozDj
LO1MDyKukPrPAEOzc3QCMYXvRAzqBNxOcJKmsUaRHdGPexs4l3Xk9G3l6LekQ0k+
Np/nBVwva/1DXVJGZvxlhpPwHHpNR10q20xE1mvxKysyrQFYr0vpNWoU6/7Qo4hQ
XdXATWq7h3HGwxz+FHknj7WbmWebY0oUQZfroDSpdjOlY92nL4M8prWuhob/Efbg
WwdMfmtQnyaqlQgC+ufY3bHbt6+ssEax/UToDp29YFxr/pnoiUl9lbeS9/hFn/1+
L0yV7tOQ7ysS7ISzJRWPXwhoospvzd8ou8/bcFfVOavjsWCTCB3sBh2HrdB09gee
h57lZplP5b46hXnPQT/iCL/rHOQ9/m3QohL/uQX/EMyUT2DSbfBcE2ZAbiVtY5Oh
vroRDynn0kZRWpRqzBIpD3zNjZrOTykNzmltSJlda2q8mSsB/hQqP3RF71zFvXeW
WKPlWpOoz1FszUl0Nul1M0yF7/LBQrJi70BZYpNIVZMScSg9X6nPZ2/uSXECAwEA
AQKCAgEAs/RR5bbbbeg23zZ4yaAqCoxUiaNvtGBWZwjjNbC9PkYVEsteorvz9GON
jIbwVXYLUJLkmcUq68atin1ikZD4++InnatQtzPVSGjD/8sywDJFDjyMuj3WtR4j
x28D+GBwSwCqDqy9p4R0OowmZ2+vHYrtjNgYtI463suihGE5xrJQ9Forwzr+odzC
uKCdtGn0e0NCLL771Mkv45IkT8YV5+uq2JcMi311ITZCK3SLEuBbHMnqLgL9gBTG
ooxqo32RpZT/AiRpSt3VfJ0mhz6YG+czxpu/8t2pPmvqxccSFTZtiNfMee9b+2+5
FgruEtlYMHgbsw3ZWc4KVrp5gZQQgdu+0p7mShtmwpDMqFDETuiIeLW8KsSmfxh+
M7Jn94HsmQT5hGvcZths3bVyICx9gQH4nCatX2axdnPC4Pxb3CZ4BeFN0r3Vx4uz
bNXRITFzO2lqTDukHjvn2y9uDWLBe0QC0WLD2Tu+CESGekowHaYIi+MH2UmxIfgi
daJa07xfpvahMc1667p9at/bWeMhBv5O8hDNpR131ao/RVpJY7COIc0IrxiQW3oe
Orb5MdBj0SnQ87+xqXSExZGj5QBTzUVJK6xtGmwchZP5Q0wQ8t8uyHcED4NFauvs
QZRhtc0tOiU72sT4/xR4KiBS7FqADCasaKC1b7Uvh0CuxtgEUAECggEBAN3fyLqc
TZ1UgIySCqq1KNWS84WpdYCPTgKb8B6IiRUvRisqk1bjlwKlEn/9td6aRNmoH63s
St+TNiKtoz9oZVf2rPDKUUvbt6JYlTw8dZsU3fY60y+dCZrXfDTkK5tzYrUX4obP
6pN+RT3ONYTqvhM5QuFYshbeWA0cq1bPSQcSuLGFjdCKMP/RQPWNgT8JKEqTO1bC
vqrr4YLqWw+bFildJJ0UcxOOKb1sUXiAA6QmLGeOl1oCzyEJTBXSmGh5YzTi+Grf
EnA7OlvQtKNJ9oA/HLNQBhWQdrf6Nooa0FTNaejPQcJnmNyj8REP1Vwff/1eqgKV
CGxhSt581jonrxECggEBANzRIPhALzPsVO9btTYoqLcCGRDZcOfPSTSjwBQD9k4z
8FoZTCkufKWi7PZ2PcR/hC0x3/DkxifeSw3ZIhi7Xs4WVYySJryHi4ASVGC0iXJB
3h4TrwRMAYo7RKPywUEjxBmGcvA2uM+1qaPvbORXxxGWjZSX79icB10n55k8BNFw
UH9wSSgFyhIu1iP9GOy10SzbVOm0wp1i/wJPqDauIDXQ9YDT1W6/TGewjrUTVrMH
Kv4LcOvmhdHQNAB7OZNPoZ/OoF+kVe/0dDkJL5nD6T2x1VoKaHW31alnFohcnSWx
LCyGcBclqwMkIzvXQKcfxNi+XpLbhoidyFsIn7z9tGECggEAdgLTVz5PogESJrJ+
7fFReNeio1NQ5kJSsdyTSQpCL3xnjAonOC3xYjy+rEkb9PyE5mggAXgPEv/P6X4F
uHIkhTb1IVXbC8gf0j/fkJxvyT6+GHuNXGPgefVnYRKDhzlGJSBBIodwM2cUGR2X
Jc1dsAfi5M0yXCuDFeZL0+6I3zQ7/GAW3/bAvTBlprXPKuIKBjBtfWYz1+GCnwlb
yd8pWHLsSIhZ9OrGlLQKWVdtmF+deq9DHWMlHGM/jtPmsJrwA289xkpEGmHGVpOZ
oMh0Th5De7RyqAGgw5ZYb/h3GsPvMx8Z0PcdPS4NyI9tYoR2pSM2tgzi4BKXqeMo
ZuI4oQKCAQA+4q/pAx5uQxfNMujgi6PAurA4xDQLUFUg0KGbEaXLj68beaje8YY+
BbBGYFYm58nUtSd5iy2DnSLyxquXL4VIW8PxTI4Lku5/grjU8ZVTHL8NAb4OEzc9
DrP1nOS8kFsAifGhx3PKc4nkTgNM5FKlB6M6diqwHX9bYEnssdMNclb6dBfhdgSe
OQhzJ1k50G3JwIzmIbxq5g6JsfXN3Lj/morQLYPTDlfMD9QUbXV7dscfolJ+XCAw
KIMmv/Edqsf0ovu5QSvYMl4HAD62I70A/OwtwFkPbVND8z/PhdCbM2HJLGAvt2KE
en4uRJb9AWcl8tEsMaiWr5inlEUppXcBAoIBAGbfsiQ9MyIX4lwNI8GojMcKpqR1
iZ1UKRasrkhLts+5HJjnF5IyKwJ8JlSTLrYQBvaEq2/Opdjab0plpsYOasOCjTLb
0qoFvnEuG/lcIjijqIN0AHQPJhFJPmaR9GuRyBZMDwG693qrBKXqDcEjOuq0iRaa
/ZKdR/DP9yP55xOThQxb0d1mmIzaZWoI/jJ8/Emi7wK+cuciguBMClCZC4vdKYvy
tNnvPKG6qTnsxldCoDJhUb/p4Cblmw9WiUJttNVYQokXlm11XvqSnFRFCYxA8igG
wk1A2EZ2uPGOkF5cP9c05b65iiT/NOtsmIO8refd0dtq6H1BNvmNklqeeFQ=
-----END RSA PRIVATE KEY-----
"""

let publicPemString = """
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAvYkQBxCX6fDYHIzHDmJW
v7Ic0Ab9f62phB2CfvG5JIvTC3UrLxta7uzm2GhJhACu0QV6K+cTX5J6jTBrHTwl
Wr8Eqsen+evMET9TxdRUl5r1Wl90RjqVjXDKLGieziouxzg9O0akjwLMoKSsDNk/
qGtcjnkUKnQlcox+b5ruFuZnnaxSqZHhzs5h0ejE9Eum1Eq/6uaz6xPCisf8Ax8N
C4La7c3InQ0VWwh724adLI3zMvMGFJIKhHFidtxSep93g9qgwEc9iswdnywsWWRW
qcQs62a/OBo/zevZT5g/524uKYgfhQbJLlAn83NXOrK3WFNcGXfGhzy1ispqDsyy
QtrgjnvJUlbTNBtiBxTbsIxU6CxvUnw5RDePUtd460L4MoVgJjrIJfNYa5g1YZIK
8AyPiuEvW3JufFoHyrZ2basavGM1G7MTwLx+ZtD4jC65VEAo0kptQXWxruhvodlg
8AMm4FOX6fumsD0ImP1c+goP6a4DTxeA8BFAqAIx1SDSdMMUUGTVmJvSR7p8bcjO
tj5+El5wGH46PyvpyiP0vNB6FxYPjQr6V2o3OfsT4PbOQYOhHFDFcfKLcinqtHW3
/hOUekom+VAKEXjM1px8/bJudc7HI9+a86B1TFW2mK/reiINT3ZrIbaHnqPGWmkk
nr2AGPwEpE/DkW8LvU891W0CAwEAAQ==
-----END PUBLIC KEY-----
"""

let publicPemString2 = """
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAv2GQxmAu8igZje44TGiR
m8sWhiot5SWy3JphXoAHX7GmCivf42V9l4tKei+k7Ka0OJ96L9Suv0zokzRlwe8Y
NuHOFQQUv5QbxJHhqOyRnITS+GVonXBvFGR4MlPc75FNDN2OvIfHMBkbaervCEzu
JFVB71cP+LelyoVF5AheBKLxozDjLO1MDyKukPrPAEOzc3QCMYXvRAzqBNxOcJKm
sUaRHdGPexs4l3Xk9G3l6LekQ0k+Np/nBVwva/1DXVJGZvxlhpPwHHpNR10q20xE
1mvxKysyrQFYr0vpNWoU6/7Qo4hQXdXATWq7h3HGwxz+FHknj7WbmWebY0oUQZfr
oDSpdjOlY92nL4M8prWuhob/EfbgWwdMfmtQnyaqlQgC+ufY3bHbt6+ssEax/UTo
Dp29YFxr/pnoiUl9lbeS9/hFn/1+L0yV7tOQ7ysS7ISzJRWPXwhoospvzd8ou8/b
cFfVOavjsWCTCB3sBh2HrdB09geeh57lZplP5b46hXnPQT/iCL/rHOQ9/m3QohL/
uQX/EMyUT2DSbfBcE2ZAbiVtY5OhvroRDynn0kZRWpRqzBIpD3zNjZrOTykNzmlt
SJlda2q8mSsB/hQqP3RF71zFvXeWWKPlWpOoz1FszUl0Nul1M0yF7/LBQrJi70BZ
YpNIVZMScSg9X6nPZ2/uSXECAwEAAQ==
-----END PUBLIC KEY-----
"""
