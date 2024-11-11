# Como dar um build e um up com o Docker no projeto Rails

## Pré-requisitos

- Docker instalado na sua máquina
- Docker Compose instalado

## Passos para configurar o projeto

1. Clone o repositório:

```sh
git clone
```

2. Navegue até o diretório do projeto:

```sh
cd microservico_autenticacao
```

3. Copie o arquivo `.env.example` para `.env`:

```sh
cp .env.example .env
```

4. Abra o arquivo `.env` e configure as variáveis de ambiente conforme necessário.

5. Copie o arquivo `config/master.key.example` para `config/master.key`:

```sh
cp config/master.key.example config/master.key
```

## Passos para dar build

1. Execute o comando para construir as imagens Docker:

```sh
docker-compose build
```

## Passos para dar up

1. Após a construção das imagens, execute o comando para iniciar os containers:

```sh
docker-compose up
```

2. Para rodar os containers em segundo plano (detached mode), use:

```sh
docker-compose up -d
```

3. Para construir e iniciar os containers em modo detached, use:

```sh
docker-compose up --build -d
```

## Parar os containers

1. Para parar os containers, execute:

```sh
docker-compose down
```

2. Para parar os containers e remover os volumes, use:

```sh
docker-compose down --rmi all --volumes
```

## Verificar os logs

1. Para verificar os logs dos containers, use:

```sh
docker-compose logs
```

2. Para verificar os logs de um serviço específico, use:

```sh
docker-compose logs <nome_do_serviço>
```

3. Para verificar os logs em tempo real, use:

```sh
docker-compose logs -f
```

Substitua `<nome_do_serviço>` pelo nome do serviço definido no `docker-compose.yml`, exemplo `microservico_autenticacao`.

## Acessar um container

1. Para acessar um container em execução, use:

```sh
docker-compose exec <nome_do_serviço> /bin/bash
```

2. Para acessar os comandos do Rails, use:

```sh
docker-compose exec <nome_do_serviço> bin/rails <comando>
```

Substitua `<nome_do_serviço>` pelo nome do serviço definido no `docker-compose.yml`, exemplo `microservico_autenticacao`.
Substitua `<comando>` pelo comando que deseja executar, exemplo `-T`.
