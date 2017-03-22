This repository holds AGL documentation (written by the IoT.bzh team) which is
 not yet merged into official AGL repository.


## How to generate pdf

Documentation is based on [gitbook](https://www.gitbook.com/).
To install locally gitbook:
```
npm install -g gitbook-cli
```

To generate documentation:
```
./gen_all_docs.sh
```

or to generate one individual doc manually:
```
gitbook pdf ./sdk-devkit ./build/sdk-devkit.pdf

```


## Notes / TODO
- Add Iot.Bzh logo in header instead of IoT.Bzh text
- Autogenerate cover https://plugins.gitbook.com/plugin/autocover