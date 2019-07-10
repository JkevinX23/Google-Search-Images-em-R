R Search ( Images & Text) 

A Linguagem R é constantemente utilizada para gerar e analisar dados com precisão. Oferece uma gama de funções para análise e obtenção de dados.

Neste projeto, é explorado o potencial de obtenção de dados. O objetivo é, obter imagens, textos e links de referência relacionados a uma determinada entrada. Para isso, foram utilizadas 2 APIs, e criadas 5 funções que serão apresentadas abaixo.

Bibliotecas utilizadas:

library("rjson")
library("httr")
library("filesstrings")
library('rvest')
library("RCurl")
Funções criadas: 

getImages

A função recebe como parâmetros, um inteiro 'num'  e uma string  'q' .O objetivo desta função é fazer o download de 'num' imagens com o tema 'q' no diretório './"q"/images'. Para isso, foi utilizado uma API da google, a google custom search, responsável por retornar um arquivo Json, usado para a obtenção dos links, que serão baixados e movidos em seguida.

getWikiLinks

A função recebe como parâmetro um inteiro 'num' e a palavra tema 'q'.  O objetivo desta função é obter URLs de artigos relacionados ao tema, escrever estas URLs em um arquivo de texto, e retornar seu caminho.
Para isto, foi utilizado a api do Wikipedia, para obter os IDs das páginas e em seguida, a URL completa correspondente.

getLines

Função auxiliar para interpretação de arquivos de textos.



getHtmlText

Recebe como parâmetro o caminho do arquivo com os links que foram obtidos em "getWikiLinks". Obtém o xml da página e em seguida obtém os textos dos parágrafos localizados no 'css selector' que foi obtido manualmente na página do wikipedia. São analisados 20 parágrafos, e obtidos aqueles que contém textos. Os textos obtidos em html são extraídos e escritos em um arquivo de texto em './"q"', .O nome deste arquivo é retornado.

Finish

Uma função auxiliar responsável por mover, renomear, e excluir arquivos de debug.
Aqui, o arquivo de texto obtido em "getWikiLinks" é renomeado para 'wikilinks.txt'. Movido para './"q"/textos juntamente com o arquivo contendo os textos que foi obtido em 'getHtmlText'.

Authors

João Kevin Gomes Rodrigues


