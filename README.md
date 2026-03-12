# mobile_arquitetura_02

Evolução da aplicação Flutter 

---

## Questionário de Reflexão

**1. Em qual camada foi implementado o mecanismo de cache? Por que essa decisão é adequada?**

O cache foi implementado na camada **data**, dentro de um datasource dedicado (`ProductCacheDatasource`). Faz sentido estar ali porque o cache é um detalhe de infraestrutura — ele decide de onde os dados vêm, não o que fazer com eles. O repositório coordena a estratégia (tenta a API, cai no cache se falhar), e as camadas superiores nem ficam sabendo disso.

**2. Por que o ViewModel não deve realizar chamadas HTTP diretamente?**

Porque o ViewModel pertence à camada de apresentação, e seu papel é coordenar o estado da tela — não buscar dados. Se ele fizesse chamadas HTTP diretamente, estaria misturando responsabilidades, dificultando testes e amarrando a interface a detalhes de infraestrutura. Trocar a API por outra fonte de dados exigiria mexer no ViewModel, o que não deveria ser necessário.

**3. O que poderia acontecer se a interface acessasse diretamente o DataSource?**

A interface passaria a depender de detalhes técnicos de acesso a dados, como formato de resposta da API e tratamento de erros HTTP. Qualquer mudança na API quebraria a interface. Além disso, seria impossível testar a UI de forma isolada, e a lógica de cache ou fallback ficaria espalhada em lugares errados.

**4. Como essa arquitetura facilitaria a substituição da API por um banco de dados local?**

Bastaria criar uma nova implementação do `ProductRepository` que usa um datasource local em vez do remoto, e trocar a injeção no `main.dart`. O ViewModel, a interface e as entidades do domínio não precisariam mudar nada, pois eles dependem apenas do contrato (`ProductRepository`), não da implementação concreta.

---

## Gerenciamento de Estado: Provider, Riverpod e BLoC

Essas três abordagens resolvem o mesmo problema — compartilhar e atualizar estado entre widgets — mas de formas diferentes.

### Provider

É a abordagem mais simples e direta. Um objeto que estende `ChangeNotifier` guarda o estado e chama `notifyListeners()` quando algo muda. Os widgets que precisam desse estado usam `Consumer` ou `context.watch` para se reconstruir automaticamente. É fácil de entender e de integrar em projetos existentes, por isso costuma ser a primeira escolha em aplicações menores.

### Riverpod

É uma evolução do Provider, mas com uma abordagem diferente: o estado é declarado fora da árvore de widgets, usando `providers` globais. Isso elimina alguns problemas do Provider original, como dependência de contexto e dificuldade em acessar estado fora de widgets. Com Riverpod, o código fica mais testável e previsível, sendo uma boa escolha para projetos de médio a grande porte.

### BLoC (Business Logic Component)

É a abordagem mais estruturada das três. O estado é gerenciado por eventos: a interface dispara um evento, o BLoC processa e emite um novo estado. Tudo flui de forma unidirecional e explícita. Por ser mais verboso, exige mais código para funcionalidades simples, mas oferece rastreabilidade total do que acontece na aplicação — ideal para times maiores ou projetos com lógica de negócio complexa.
