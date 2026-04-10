# Quotes API

API desenvolvida em Ruby on Rails (API Only) para busca de frases por tag, com cache em MongoDB, processamento assíncrono com Sidekiq e autenticação via JWT.

**Ruby:** 3.4.4  
**Rails:** 8.1.3

---

## Quick Start

```bash
git clone https://github.com/guimelo03/ApiQuotesApp.git
cd api_quotes_app
bundle install

# Subir dependências
mongod
redis-server

# Subir aplicação + worker
foreman start 
```

OBS: ao iniciar no foreman, o servidor irá subir na porta 5000. (localhost:5000)

---

## Tecnologias utilizadas

* Ruby on Rails (API Only)
* MongoDB (Mongoid)
* Sidekiq + sidekiq-cron
* Redis
* JWT (autenticação)
* ActiveModelSerializers
* RSpec (testes de integração)

---

## Arquitetura

A aplicação segue uma estrutura baseada em separação de responsabilidades:

* **Controller** → Orquestra a requisição
* **Service** → Encapsula lógica de negócio (padronizado com ServiceBase)
* **Model (Mongoid)** → Persistência e cache
* **Job (Sidekiq)** → Processamento assíncrono
* **Serializer** → Formatação da resposta JSON

---

## Como funciona

### Fluxo principal

1. O cliente faz uma requisição para:

```http
GET /quotes/:tag
```

2. A API verifica se a tag já existe no cache (MongoDB)

* Se existir → retorna os dados imediatamente (**200 OK**)
* Se não existir → dispara um job e retorna (**202 Accepted**)

3. O job busca dados em:

* http://quotes.toscrape.com
* https://quotes.toscrape.com/api/quotes

4. Os dados são armazenados no MongoDB como cache

---

⚠️ Na primeira requisição, a API pode retornar **202 Accepted**, indicando que o cache está sendo gerado em background. Tente novamente após alguns segundos.

⚠️ É necessário rodar o **Sidekiq** para que o cache seja preenchido corretamente.

---

## Autenticação (JWT)

### Gerar token

```bash
curl -X POST http://localhost:5000/login \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "email=admin@email.com&password=123456"
```

Resposta:

```json
{
  "token": "SEU_TOKEN"
}
```

---

### Usar token

```bash
curl http://localhost:5000/quotes/love \
  -H "Authorization: Bearer SEU_TOKEN"
```

---

## Testes

A aplicação possui testes de integração utilizando RSpec.

Para rodar:

```bash
bundle exec rspec
```

Os testes cobrem:

* Autenticação
* Acesso ao endpoint
* Comportamento com cache
* Comportamento sem cache
* Funcionamento do JWT
* Execução de jobs assíncronos
* Lógica de negócio via services

---

## Setup detalhado

### Dependências

A aplicação depende de:

- MongoDB -> utilizado como cache por tag
- Redis -> utilizado pelo Sidekiq para processamento assíncrono

### Observações

- O Sidekiq depende do Redis ativo para funcionar corretamente.
- Em caso de inconsistência no Redis, é possível limpar os dados com:
```bash
  redis-cli flushall
```

---

### Execução da aplicação

O projeto utiliza o Foreman para subir múltiplos processos (Rails + Sidekiq)

---

## Jobs agendados

A aplicação utiliza `sidekiq-cron` para executar jobs periodicamente.

Exemplo:

* Atualização de cache a cada 12 horas

---

## Estrutura de dados

### TagCache

* `tag` (string)
* `quotes` (embedded)

### Quote

* `content`
* `author`
* `author_about`
* `tags`

---

## Exemplo de resposta

```json
{
  "quotes": [
    {
      "quote": "It is better to be hated...",
      "author": "André Gide",
      "author_about": "https://quotes.toscrape.com/author/show/7617.Andr_Gide",
      "tags": ["life", "love"]
    }
  ]
}
```

---

## Decisões técnicas

* Uso de **MongoDB** para simular cache por tag
* Uso de **Sidekiq** para evitar bloqueio da requisição
* Uso de **JWT** para proteger endpoints
* Uso de **Service Objects** para organizar regras de negócio
* Uso de **Serializers** para padronizar respostas

---

## Possíveis melhorias

* Evitar múltiplos jobs simultâneos por tag
* Implementação de usuários reais
* Refresh token
* Dockerização da aplicação
* .env para guardar URLs, URIs e outras variáveis/tokens.

---

## Autor

Desenvolvido por **Guilherme Melo Alves**
