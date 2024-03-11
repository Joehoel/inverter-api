# PowerPoint Inverter API

To develop this project you need to have Rye installed: https://rye-up.com/

```sh
rye sync
rye run dev
```

To test the API you can use the following command:

```sh
curl -X POST -F "upload=@example/white.pptx" https://inverter-api.fly.dev/upload -o ./example/black.pptx
```
