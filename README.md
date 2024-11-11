# Projeto com Docker Compose

Este projeto utiliza **Docker Compose** para gerenciar seus serviços. Siga as instruções abaixo para iniciar, parar e gerenciar o ambiente do projeto.

## Pré-requisitos

- Certifique-se de que o **Docker** e o **Docker Compose** estão instalados em sua máquina.
- [Instale o Docker](https://docs.docker.com/get-docker/).
- [Instale o Docker Compose](https://docs.docker.com/compose/install/).

## Comandos Básicos

### 1. Iniciar o Projeto com Build

Para iniciar os containers e garantir que o código mais recente seja construído, use o seguinte comando:

```bash
docker-compose up --build -d
```

- **`--build`**: Reconstrói as imagens antes de iniciar os containers.
- **`-d`**: Roda os containers em modo **detached** (em segundo plano).

Este comando irá:

- Construir as imagens do projeto.
- Inicializar todos os serviços configurados no arquivo `docker-compose.yml`.

### 2. Parar o Projeto

Para parar os containers que estão em execução:

```bash
docker-compose down
```

- Este comando irá:
  - Parar todos os containers em execução.
  - Remover os containers, redes e volumes anônimos associados.

### 3. Visualizar Logs

Se você quiser ver os logs dos serviços em tempo real:

```bash
docker-compose logs -f
```

- **`-f`**: Segue os logs continuamente.
- Você também pode visualizar logs de um serviço específico:

  ```bash
  docker-compose logs -f <service_name>
  ```

### 4. Reiniciar os Containers

Para reiniciar rapidamente os serviços:

```bash
docker-compose restart
```

- Para reiniciar um serviço específico:

  ```bash
  docker-compose restart <service_name>
  ```

### 5. Verificar o Status dos Containers

Para verificar o status dos serviços em execução:

```bash
docker-compose ps
```

### 6. Executar um Comando em um Container

Para executar comandos dentro de um container:

```bash
docker-compose exec <service_name> <command>
```

Exemplo:

```bash
docker-compose exec app bash
```

### 7. Remover Volumes Persistentes (Opcional)

Se precisar remover os volumes associados ao projeto:

```bash
docker-compose down -v
```

- **`-v`**: Remove os volumes criados pelo `docker-compose`.

---

## Estrutura do Projeto

Aqui está um exemplo da estrutura básica do projeto:

```
.
├── projeto_principal/
├── microservico_autenticacao/
├── microservico_notificacao/
├── microservico_webscraping/
├── docker-compose.yml
└── README.md
```

## Notas

- Certifique-se de configurar corretamente as variáveis de ambiente no arquivo `docker-compose.yml` ou em arquivos `.env` se utilizados.
- Para personalizações, você pode modificar os serviços diretamente no `docker-compose.yml`.

---

## Suporte

Se encontrar problemas, sinta-se à vontade para abrir uma issue ou entrar em contato com o time responsável.

---

Este **README.md** contém instruções claras para iniciar, parar e gerenciar seu projeto com **Docker Compose**, garantindo que as imagens sejam sempre atualizadas com o comando **`--build`**. 🚀
