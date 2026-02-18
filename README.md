# About

- `./frontend` - vuejs frontend
- `./backend` - rust backend api
- `./analytics` - python data-science thing
- `./infra` - docker

### Usage

_Run the analytics_

```sh
nix run .#analytics-compute
```

_Compile the backend_

```sh
cd backend
cargo build
```

_Hack on the frontend_

```sh
cd frontend
npm install
npm run dev
```

_Run the back/front-end stack locally_

```sh
nix run .#serve
```

_Same thing, but with docker-compose this time_

```sh
cd infra
./build-docker-images
docker compose up
```

There's more you can do; take a look around!
