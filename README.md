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

1. O que é gerenciamento de estado no Flutter?
É como o app guarda e controla as informações que aparecem na tela. Se um dado muda (como um contador ou um nome), o gerenciamento de estado garante que a interface seja redesenhada para mostrar o valor novo. É o "cérebro" que decide o que a tela exibe em cada momento.
2. Por que evitar estado direto nos widgets em apps grandes?
Porque a informação fica "presa" dentro do widget. Se você precisar desse dado em outra tela, terá que passá-lo manualmente de pai para filho em uma corrente infinita (o famoso prop drilling). Isso deixa o código bagunçado, difícil de consertar e impossível de escalar.
3. Para que serve o notifyListeners() no Provider?
Ele funciona como um "alerta geral". Sempre que você altera um dado dentro da classe, precisa chamar esse método para avisar ao Flutter: "Ei, a informação mudou! Quem estiver usando esse dado agora, favor se atualizar". Sem ele, o valor muda no código, mas a tela continua igual.
4. Qual a diferença entre Provider e Riverpod?
A principal diferença é a dependência do contexto. O Provider precisa estar "dentro" da árvore de widgets para ser acessado. Já o Riverpod funciona de forma global: você define os estados fora da árvore, o que permite acessá-los de qualquer lugar (até fora da interface) de um jeito mais seguro e fácil de testar.
5. No BLoC, por que a interface não muda o estado diretamente?
Para manter a organização. No BLoC, a tela só "pede" coisas enviando eventos; ela não decide como as coisas mudam. Isso separa a lógica de negócio (o que acontece) da interface (o que aparece), evitando que o código vire uma bagunça onde tudo faz tudo.
6. Qual a vantagem do fluxo Evento → BLoC → Estado → Tela?
A previsibilidade. Como o caminho é sempre o mesmo, fica muito fácil encontrar erros (debug). Você sabe exatamente qual evento gerou qual mudança. Além disso, permite testar a lógica do app sem nem precisar abrir o emulador, já que o BLoC funciona de forma independente da interface.
7. Qual estratégia você usou e por quê?
Usei o Provider. Escolhi ele pela simplicidade e rapidez. Como a função de favoritos era algo visual e direto, o ChangeNotifier resolveu o problema perfeitamente, mantendo o código limpo e sem a complexidade desnecessária de padrões mais robustos.
8. Quais foram as maiores dificuldades?
O maior desafio foi o desempenho da árvore de widgets. No início, o app reconstruía a lista inteira cada vez que eu favoritava um item, o que causava lentidão. A solução foi "fechar o cerco": coloquei o Consumer apenas no item específico da lista, garantindo que só aquele botão fosse atualizado, deixando a navegação bem mais fluida.

---

## Questionário — Atividade 06

**1. Qual era a estrutura do seu projeto antes da inclusão das novas telas?**

O projeto tinha uma única tela, a `ProductPage`, que já era aberta direto ao iniciar o app. Ela carregava os produtos da API, exibia a lista e permitia marcar favoritos com checkbox. Não havia nenhum fluxo de navegação  era tudo em uma tela só.

**2. Como ficou o fluxo da aplicação após a implementação da navegação?**

O app agora começa na `HomePage`, que tem um botão para abrir a lista de produtos. A partir da `ProductPage`, o usuário pode tocar em qualquer produto para abrir a `ProductDetailPage` com as informações completas. O fluxo ficou: `HomePage` → `ProductPage` → `ProductDetailPage`.

**3. Qual é o papel do `Navigator.push()` no seu projeto?**

Ele é usado em dois momentos: na `HomePage` para abrir a `ProductPage`, e na `ProductPage` para abrir a `ProductDetailPage` quando o usuário toca em um item. Em ambos os casos, a nova tela é empilhada sobre a anterior, mantendo o histórico de navegação.

**4. Qual é o papel do `Navigator.pop()` no seu projeto?**

O `pop` é gerenciado automaticamente pelo Flutter através do botão de voltar nativo do dispositivo e da seta na `AppBar`. Não foi necessário chamá-lo manualmente, pois o comportamento padrão já resolve, ao voltar, a tela atual é removida da pilha e a anterior reaparece.

**5. Como os dados do produto selecionado foram enviados para a tela de detalhes?**

O objeto `Product` foi passado diretamente como parâmetro no construtor da `ProductDetailPage` dentro do `MaterialPageRoute`. Quando o usuário toca em um item, o `onTap` captura o produto daquele índice e o entrega para a próxima tela na hora do `Navigator.push`.

**6. Por que a tela de detalhes depende das informações da tela anterior?**

Porque ela não busca nada da API por conta própria, ela apenas exibe o que recebe. A lista já carregou e mapeou todos os dados do produto, então faz sentido simplesmente repassá-los. Não haveria motivo para fazer uma segunda requisição para algo que já está disponível.

**7. Quais foram as principais mudanças feitas no projeto original?**

Foram criadas duas novas páginas (`HomePage` e `ProductDetailPage`) e o campo `description` foi adicionado à entidade `Product`, ao `ProductModel` e ao mapeamento do repositório, já que a tela de detalhes precisava exibir essa informação. O `main.dart` passou a apontar para a `HomePage`, e a `ProductPage` recebeu o `onTap` nos itens da lista.

**8. Quais dificuldades você encontrou durante a adaptação do projeto para múltiplas telas?**

A maior dificuldade foi perceber que a entidade `Product` não tinha o campo `description`, que a API já retorna. Como a `ProductDetailPage` precisava exibir esse dado, foi necessário atualizar a entidade, o model e o repositório ao mesmo tempo — um ajuste simples, mas que tocou em três camadas diferentes da arquitetura ao mesmo tempo.
