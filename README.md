# About

- `./frontend` - vuejs frontend
- `./backend` - rust backend api
- `./analytics` - python data-science thing
- `./infra` - docker

This code is accompanied by the following article: [How to monorepo with
Nix](https://invariant.club/articles/how-to-monorepo-with-nix.html).

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

### Trivia

- Be particularly careful about making sure the Nix files you are writing are
  committed to source control. Nix will not pick up files that are not added,
  and you may get confusing errors (i.e. expecting outputs to be present but
  they are not because the file is being silently ignored.)
