# README
## Informações do Projeto

- **Versão do Ruby**: 3.2.1 (ou a versão especificada no arquivo `.ruby-version`)
- **Versão do Rails**: 8.0.2
- **Banco de Dados**: PostgreSQL (configuração padrão para projetos Rails modernos)
- **Yarn**: 1.22.19 (ou a versão especificada no ambiente)
- **Node.js**: 18.x (ou a versão especificada no ambiente)
- **React**: 17.x (ou a versão especificada no `package.json`)

## Dependências e Configuração

1. Certifique-se de ter o Ruby, Node.js e o PostgreSQL instalados.
2. Instale as dependências do backend com:
    ```bash
    bundle install
    ```
3. Instale as dependências do frontend com:
    ```bash
    yarn install
    ```

## Como Rodar o Projeto local

1. Configure o banco de dados:
    ```bash
    rails db:setup
    ```
2. Inicie o projeto com o comando:
    ```bash
    bin/dev
    ```
3. Acesse a aplicação em [http://localhost:3000](http://localhost:3000).

## Como Rodar o Projeto com Docker

1. Inicie o projeto com o comando:
    ```bash
    docker compose up --build
    ```
2. Acesse a aplicação em [http://localhost:3000](http://localhost:3000).

3. Instale dependências React

> [!WARNING]
> Você pode receber o erro `ActionView::Template::Error (The asset ‘application.js’ is not present in the asset pipeline.`
>
> O erro ocorre porque os recursos não foram compilados no modo de desenvolvimento, `bin/rails assets:precompile`

## Como Rodar os testes com Docker

Executa os testes (rspec) no container `app`:
  ```bash
  docker compose run --rm test
  ou
  docker compose exec app bash
  bundle exec rspec spec/
  ```

# Comandos Docker Utilizados

### 1. `docker compose up`
- **Resumo**: Inicia os containers definidos no arquivo `docker-compose.yml`. Se os containers ainda não existirem, ele os cria. Esse comando também pode ser usado para rodar a aplicação.
- **Exemplo**: 
  ```bash
  docker compose up
  ```

### 2. `docker compose up --build`
- **Resumo**: Inicia os containers e recria as imagens se houverem alterações no Dockerfile ou no contexto de build. Isso garante que a aplicação seja reconstruída com as últimas mudanças.
- **Exemplo**:
  ```bash
  docker compose up --build
  ```

### 3. `docker compose down`
- **Resumo**: Derruba os containers e remove redes, volumes e imagens associadas aos containers. Esse comando é útil quando você quer parar tudo e recomeçar.
- **Exemplo**:
  ```bash
  docker compose down
  ```

### 4. `docker compose logs app`
- **Resumo**: Exibe os logs do serviço `app` definido no `docker-compose.yml`. É útil para verificar o que está acontecendo dentro do container ou identificar erros.
- **Exemplo**:
  ```bash
  docker compose logs app
  ```

### 5. `docker compose exec app bash`
- **Resumo**: Executa um comando dentro do container em execução, no caso `app`. No exemplo, é aberto um shell interativo (`bash`) dentro do container, permitindo que você execute comandos dentro do ambiente do container.
- **Exemplo**:
  ```bash
  docker compose exec app bash
  ```

### 6. `ps aux | grep rails`
- **Resumo**: Comando do sistema operacional (não específico do Docker) que lista todos os processos em execução. Com `grep rails`, filtra os processos relacionados ao Rails. É útil para verificar se o servidor Rails está rodando dentro do container.
- **Exemplo**:
  ```bash
  ps aux | grep rails
  ```

### 7. `docker compose build`
- **Resumo**: Reconstrói as imagens Docker para os serviços definidos no arquivo `docker-compose.yml`, sem iniciar os containers. Pode ser útil para reconstruir as imagens quando há alterações no Dockerfile ou nas dependências.
- **Exemplo**:
  ```bash
  docker compose build
  ```

### 8. `docker compose run app rails db:create`
- **Resumo**: Executa um comando específico no container de um serviço. No exemplo, o comando `rails db:create` é executado no serviço `app`, criando o banco de dados do Rails. Este comando é útil para rodar tarefas específicas dentro do container.
- **Exemplo**:
  ```bash
  docker compose run app rails db:create
  ou
  docker compose run app bundle exec rails db:create
  ```

### 9. `docker compose run app rails db:migrate`
- **Resumo**: Executa as migrações do banco de dados no container `app`. O comando aplica as mudanças no banco de dados de acordo com os arquivos de migração do Rails.
- **Exemplo**:
  ```bash
  docker compose run app rails db:migrate
  ou
  docker compose run app bundle exec rails db:migrate
  ```
