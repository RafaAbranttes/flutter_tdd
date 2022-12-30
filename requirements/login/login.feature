Feature: Login
Como um cliente 
QUero poder acecssar minha conta e me manter logado
Para que eu possa ver e responder enquetes de forma rápida

Cenário: Credenciais Válidas
Dado que o cliente informou credenciais Válidas
Quando solicitar para fazer Login
Então o sistema deve enviar o usuário para a tela de pesquisas 
E manter o usuário conectado

Cenário: Credenciais Inválidas
Dado que o cliente informou credenciais Inválidas
Quando solicitar para fazer login 
Então o sistema deve retornar uma mensagem de erro
