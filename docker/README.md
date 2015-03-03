## Building docker image

```bash
cp ../../*.deb .
sudo docker build -t andresriancho/w3af-kali .
```

## Debugging
```bash
sudo docker run -i -t --privileged --rm andresriancho/w3af-kali /bin/bash
```