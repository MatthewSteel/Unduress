Unduress
========

Deniable duress-codes for disposable encryption
-----------------------------------------------

Unduress is a service to close one of the last remaining security vectors in your data storage scheme: rubber-hose cryptanalysis. It creates a password scheme that irreversibly locks encrypted files when particular passwords are used.

Most non-physical countermeasures are ineffective for this purpose — simply deleting the encrypted data will not deter an attacker with the ability and the foresight to first back it up. Unduress works by storing essential keys on a secure remote server where they can be deleted safely.

Before attempting to unlock a file, an attacker can't tell a correct password from a duress password from a wrong password. After an unsuccessful decryption attempt, an attacker still can't tell if they used the duress password. Best of all, your data is safe even if our security is compromised (though your duress passwords may be rendered ineffective.)

The Tour
--------

    $ unduress encrypt File > File.crypt
    Enter password:
    Enter duress password:

"File.crypt" now contains "File" safely encrypted. Continuing,

    $ unduress decrypt File.crypt > File2
    Enter password:

If we give the right password our data ends up in "File2". If we give the wrong password an error is reported and File remains empty. If we give the duress password an error is returned, and the encrypted data is lost forever.

Note that multiple files encrypted with the same password-pairs are not "linked" - using the duress password on one does not disable the others. If you want to be able to disable multiple files at once, see the advanced usage guide.

Get Unduressed
--------------

Just download Unduress and you're ready to go, no registration or anything like that. Requires bash, gpg and cURL; TOR is recommended too. Everything on this domain is licensed under the WTFPL.

FAQ:
----

*   **Can you intercept my password or read my encrypted data?**
    
    No. There is absolutely no data-dependence between your password or your data and the contents of our database. If you don't believe me you can check the source code — everything that is sent to the server is randomly generated on the client-side.

*   **I forgot my password. Can you help?**
    
    No. Mourn for your data.

*   **Do you keep backups?**
    
    No. Backing up server data would defeat the duress password scheme.

*   **Do you keep server logs?**

    Some general usage logs are kept, nothing identifiable (to my knowledge). Use TOR anyway.

*   **What could happen if the site is compromised?**

        * Loss of encrypted data

        * "Duress passwords" rendered ineffective.

    Detected security breaches are documented here. If you believe that app security has been breached, or if you discover a vulnerability in either the implementation or the abstract mechanism of this service, please contact me.

*   **Will you comply with legal requests for data?**

    If compelled to. Such requests will be documented as security breaches and have the same practical ramifications. If a request cannot be legally disclosed this service will cease.

*   **Is my use of your service legal?**

    Ask a lawyer.

*   **How does it work? Is there an API?**

    We only keep one thing on the server: matched pairs of random keys and random codes for each key, like so:

        (key1, code1) : (key2, code2)

    When key1 is accessed (i.e., when you decrypt your data), code2 is reset to a random value. When key2 is accessed (when you type in your duress password), code1 is randomised, and subsequent decryptions relying on it fail.

    Feel free to use this service for your own purposes with our hilarious html, json and plain text interfaces. It might be cool to have a service for triggering duress codes via email or SMS, but I probably won't write it unless I get really damn bored.
    
*   **Anything else?**
    
    This site is hosted on Google App Engine. Google's legal, logging and backup policies may differ from my own.

Advanced use:
-------------

    $ unduress gen > keyfile
    Enter password:
    Enter duress password:

This generates a "keyfile". This file can be used to encrypt multiple files, all with the same passwords, and all of which get disabled when the duress password is used on any one of them. Encryption using a keyfile looks like this,

    $ unduress key-encrypt file keyfile > file.kcrypt
    Enter password:

and decrypting a keyfile-encrypted file looks like this:

    $ unduress key-decrypt file.kcrypt keyfile > file
    Enter password:

This also provides a little extra safety - if you keep the only copy of the "keyfile" on a USB stick, deleting it (or destroying the stick) will also disable all files encrypted with it.

Finally, to go between keyfile-encrypted files and "normally encrypted" ones, you can attach, detach and get keyfiles from files like so:

    $ unduress key-attach file.kcrypt keyfile > file.crypt
    $ unduress key-detach file.crypt > file.kcrypt
    $ unduress key-get file.crypt > keyfile

Unduress does not prevent you from attaching unrelated keyfiles to your encrypted data. Make of that information what you will.
 
