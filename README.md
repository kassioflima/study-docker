# Cluster Docker Swarm local com Vagrant

## Visão geral

Este projeto provisiona um ambiente local de alta disponibilidade com um cluster Docker Swarm composto por quatro máquinas virtuais, simulando uma topologia de produção em um contexto de laboratório.

A arquitetura foi organizada para demonstrar os conceitos fundamentais de orquestração de containers, provisionamento automatizado e gestão de nós em um cluster distribuído.

## Objetivo

O ambiente foi criado para:

- provisionar automaticamente um cluster Docker Swarm local;
- validar a comunicação entre manager e workers;
- demonstrar a criação e o gerenciamento de serviços distribuídos;
- fornecer uma base educativa para estudos de DevOps e arquitetura de infraestrutura.

## Arquitetura

A infraestrutura é composta por:

| Máquina | IP privado | Papel | Observação |
|---|---:|---|---|
| `master` | `192.168.56.10` | Manager | Inicializa o Swarm e coordena os workers |
| `node01` | `192.168.56.11` | Worker | Recebe tarefas do scheduler do Swarm |
| `node02` | `192.168.56.12` | Worker | Participa do cluster como nó de execução |
| `node03` | `192.168.56.13` | Worker | Participa do cluster como nó de execução |

### Topologia

```text
+---------------------------+
|        Host local         |
|  Vagrant + VirtualBox     |
+-------------+-------------+
              |
              v
+---------------------------+
|         master            |
|  Docker Swarm Manager     |
|  192.168.56.10            |
+-------------+-------------+
              |
       +------|------+
       |             |
       v             v
+----------+   +----------+
| node01   |   | node02   |
| worker   |   | worker   |
+----------+   +----------+
       |
       v
+----------+
| node03   |
| worker   |
+----------+
```

## Requisitos

Antes de iniciar, certifique-se de que os seguintes componentes estejam instalados:

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://developer.hashicorp.com/vagrant)

## Provisionamento do ambiente

No diretório raiz do projeto, execute:

```bash
vagrant up
```

Durante o provisionamento, o processo realiza as seguintes ações:

1. cria as quatro máquinas virtuais Ubuntu;
2. instala o Docker Engine e os componentes necessários;
3. inicializa o Swarm no nó `master`;
4. gera e distribui o token de entrada para os workers;
5. conecta automaticamente `node01`, `node02` e `node03` ao cluster.

> A primeira execução pode levar mais tempo, pois envolverá download da imagem base, instalação de pacotes e configuração do Docker.

## Validação do cluster

Verifique os nós do Swarm:

```bash
vagrant ssh master -c "docker node ls"
```

O resultado esperado inclui:

- `master` com status `Leader`;
- `node01`, `node02` e `node03` com status `Ready`;
- total de 4 nós ativos no cluster.

## Deploy de serviço de teste

A fim de validar a execução distribuída, será criado um serviço com três réplicas:

```bash
vagrant ssh master -c "docker service create --name web --replicas 3 -p 8080:80 nginx:alpine"
vagrant ssh master -c "docker service ls"
vagrant ssh master -c "docker service ps web"
```

Esse serviço demonstra a orquestração e a distribuição de carga entre os workers do cluster.

## Remoção do serviço de teste

```bash
vagrant ssh master -c "docker service rm web"
```

## Comandos úteis

```bash
vagrant status
vagrant ssh master
vagrant halt
vagrant destroy -f
```

Também é possível reaproveitar a configuração do ambiente sem destruir o cluster:

```bash
vagrant provision
```

Os scripts de provisionamento verificam se cada nó já participa de um Swarm antes de reiniciar a inicialização ou a junção ao cluster, tornando a execução idempotente.

## Observações de operação

- O arquivo temporário `.worker_join_token` é criado no diretório compartilhado durante o provisionamento;
- esse arquivo é usado apenas para a etapa de associação dos workers;
- ele não é versionado pelo Git e pode ser ignorado pelo controle de versão.

## Conclusão

Este laboratório oferece uma base prática para compreender a arquitetura de um cluster Docker Swarm em um ambiente controlado, permitindo experimentação com conceitos de gerenciamento de nós, escalabilidade, distribuição de serviços e automação de infraestrutura.
