# homebrew-mutt

[Homebrew](http://brew.sh) tap for the [mutt](http://www.mutt.org) e-mail client.

## Why?

Much of [mutt]'s functionality is not implemented in its core code, but in 3rd party patches. Unfortunately, with mutt 1.5.24 some of these patches caused problems, so the [homebrew] project [decided to remove most patches from the default mutt formula].

The [x-way blog] provides a [formula] for mutt 1.5.24 with the `trashfolder` patch and `indexcolor` patch, however the resulting mutt version does not seem to run stable for me (I got segmentation faults).

I ended up cloning [kevwil/patches/mutt], which is based on [mutt] 1.5.23, and add some patches I need.

## How to?

In case you have a previous version of [mutt] installed, uninstall it first:

```bash
brew rm mutt
```

Then run

```
brew install fstab/mutt/mutt \
    --with-gpgme  \
    --with-trash-patch  \
    --with-sidebar-patch  \
    --with-confirm-attachment-patch
```

This should also install [gpgme], if not, install it manually

```bash
brew install gpgme
```

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
