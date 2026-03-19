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

---

## Questionário — Atividade 05

**1. O que significa gerenciamento de estado em uma aplicação Flutter?**

É a forma como a aplicação armazena e controla as informações que afetam a interface. Quando o estado muda, os widgets que dependem dele precisam ser reconstruídos. Gerenciar estado é basicamente decidir onde essas informações ficam guardadas e como as mudanças chegam até a tela.

**2. Por que manter o estado diretamente dentro dos widgets pode gerar problemas em aplicações maiores?**

Porque o estado fica preso dentro do widget e não pode ser compartilhado com outras partes da tela sem ser passado manualmente por parâmetro. Conforme a aplicação cresce, isso vira um problema: qualquer mudança precisa percorrer uma cadeia enorme de widgets, o código fica difícil de manter e qualquer refatoração vira um trabalho enorme.

**3. Qual é o papel do método `notifyListeners()` na abordagem Provider?**

É ele quem avisa os widgets que algo mudou. Quando o estado é alterado dentro do `ChangeNotifier`, o `notifyListeners()` sinaliza para todos os `Consumer` e `context.watch` registrados que precisam se reconstruir. Sem essa chamada, a interface não atualiza, mesmo que o valor tenha mudado.

**4. Qual é a principal diferença conceitual entre Provider e Riverpod?**

O Provider depende do contexto do Flutter para acessar o estado, o que cria uma limitação: você só consegue ler um provider de dentro da árvore de widgets. O Riverpod resolve isso declarando os providers fora dessa árvore, tornando o estado acessível de qualquer lugar, inclusive em funções e testes, sem precisar de contexto.

**5. No padrão BLoC, por que a interface não altera diretamente o estado da aplicação?**

Porque no BLoC a interface só tem um papel: disparar eventos e mostrar estados. A lógica de decidir o que fazer com um evento fica no BLoC. Se a interface alterasse o estado diretamente, ela estaria assumindo uma responsabilidade que não é dela, misturando apresentação com lógica de negócio e quebrando a separação que o padrão propõe.

**6. Qual é a vantagem de organizar o fluxo como: Evento → Bloc → Novo estado → Interface?**

O fluxo é completamente previsível e rastreável. Dado um evento e um estado inicial, você sempre sabe o que vai acontecer. Isso facilita muito o debug, porque qualquer comportamento inesperado pode ser encontrado em um lugar só — o BLoC. Também torna o código mais fácil de testar, já que você pode testar o BLoC de forma isolada sem precisar renderizar nenhum widget.

**7. Qual estratégia de gerenciamento de estado foi utilizada em sua implementação?**

Foi utilizado o **Provider**. A escolha foi pela simplicidade: a funcionalidade de favoritos é puramente local e visual, sem necessidade de persistência ou lógica complexa. Um `ChangeNotifier` com um `Set` de IDs favoritos resolveu o problema de forma direta e com pouco código adicional.

**8. Durante a implementação, quais foram as principais dificuldades encontradas?**

A parte mais confusa foi garantir que o `Consumer` estivesse no lugar certo dentro da árvore de widgets. Num primeiro momento, o `Consumer<FavoritesNotifier>` foi colocado fora do `ValueListenableBuilder` do estado da lista, o que fazia com que toda a lista fosse reconstruída ao favoritar um item — incluindo o recarregamento visual de todas as imagens. Mover o `Consumer` para dentro do `itemBuilder`, envolvendo apenas o `ListTile` individual, resolveu o problema e fez com que somente o item tocado fosse reconstruído.
