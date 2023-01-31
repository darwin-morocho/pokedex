# pokedex


## Local deploy
- First install all dependencies
```shell
flutter pub get
```

- Next generate the code using 
```shell
flutter pub run build_runner build
```


Now you are ready to run the project using
```shell
flutter run --dart-define=BASE_API_URL=https://pokeapi.co --dart-define=BASE_IMAGE_URL=https://www.pkparaiso.com/imagenes/pokedex/pokemon/
```

> NOTE: to run on web make sure that you are using html renderer instead of canvaskit