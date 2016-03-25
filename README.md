# homebrew-mutt

[Homebrew](http://brew.sh) tap for the [mutt](http://www.mutt.org) e-mail client.

## What's wrong with the official mutt formula?

Much of [mutt]'s functionality is not implemented in its core code, but in 3rd party patches. Unfortunately, with mutt 1.5.24 some of these patches caused problems, so the [homebrew] project [decided to remove most patches from the default mutt formula].

The [x-way blog] provides a [formula] for mutt 1.5.24 with the `trashfolder` patch and `indexcolor` patch, however the resulting mutt version does not seem to run stable for me (I got segmentation faults).

I ended up cloning [kevwil/patches/mutt], which is based on [mutt] 1.5.23, and add some patches I need.

## How to?

In case you have a previous version of [mutt] installed, uninstall it first:

```bash
brew rm mutt
```

Then run `brew install fstab/mutt/mutt`, and add a `--with-<patch>` option for each patch you want to include. The resulting command should be something like:

```
brew install fstab/mutt/mutt \
    --with-gpgme  \
    --with-trash-patch  \
    --with-sidebar-patch  \
    --with-confirm-attachment-patch \
    --with-ssl-client-certificate-without-smtp-authentication-patch
```

Here is an overview of the available patches:

  * `--with-trash-patch`: Move deleted messages to trash folder.
  * `--with-sidebar-patch`: Nice sidebar that shows folder list.
  * `--with-ignore-thread-patch`: Permanently ignore threads.
  * `--with-confirm-attachment-patch`: If you compose a mail containing the word _attach_, but nothing is attached, mutt will ask if you forgot to attach something before sending. See the arch linux [mutt-kiss] package.
  * `--with-ssl-client-certificate-without-smtp-authentication-patch`: My SMTP server uses SSL client certificates for SMTPS connections, but does not support any additional authentication. This is not supported in the original mutt. Without this patch, if you use a client certificate for SMTPS, you must have some SMTP authentication, otherwise you get the error `SMTP server does not support authentication`. This patch turns off SMTP authentication when using SSL client ceritficates, see also [here].

There are a few more options that are not related to patches:

  * `--with-debug`: Build with debug option enabled.
  * `--with-s-lang`: Build against slang instead of ncurses.
  * `--with-gpgme`: Build with [gpgme] support, which makes GnuPG configuration a lot simpler. This should also install the gpgme formula, if not install it manually with `brew install gpgme`.

## License

The project was originally cloned from [kevwil/homebrew-patches] and remains under [Kevin Williams's MIT license].

[Homebrew]: http://brew.sh
[mutt]: http://www.mutt.org
[homebrew]: http://brew.sh
[decided to remove most patches from the default mutt formula]: https://github.com/Homebrew/homebrew/pull/43647
[x-way blog]: https://blog.x-way.org/Linux/2015/09/23/Homebrew-Tap-for-Mutt-1-5-24-with-trash_folder-patch.html
[formula]: https://github.com/x-way/homebrew-mutt
[kevwil/patches/mutt]: https://github.com/kevwil/homebrew-patches
[gpgme]: https://www.gnupg.org/(es)/related_software/gpgme/index.html
[kevwil/homebrew-patches]: https://github.com/kevwil/homebrew-patches
[Kevin Williams's MIT license]: https://github.com/fstab/homebrew-mutt/blob/master/LICENSE
[mutt-kiss]: https://aur.archlinux.org/packages/mutt-kiss/
[here]: https://www.mail-archive.com/mutt-dev@mutt.org/msg08970.html
