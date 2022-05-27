;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
; UNIVERSIDADE FEDERAL DA PARAÍBA - UFPB  |  
; CENTRO DE INFORMATICA - CI              |  
; DISCIPLINA: ARQUITETURA DE COMPUTADORES |
; PROFESSOR: EWERTON MONTEIRO SALVADOR    |
; DUPLA: GABRIEL FORMIGA | JOHAN KEVIN    |
; PROJETO 1/2 - LINGUAGEM ASSEMBLY.       |
;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


    ;---------------- IMPORT BLIBLIOTECAS -----------------|
.486

.model flat, stdcall
option casemap :none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib

    ;-------------------------- DATA -----------------------|

.data


    ;----------------------- MENSAGENS ---------------------|

    textox1 db 0ah, "Digite o valor de x1: ", 0h                           ;-- Captura o valor do ponto x1.------------------|
    textox2 db 0ah, "Digite o valor de x2: ", 0h                           ;-- Captura o valor do ponto x2.------------------|
    textoy1 db 0ah, "Digite o valor de y1: ", 0h                           ;-- Captura o valor do ponto y1.------------------|
    textoy2 db 0ah, "Digite o valor de y2: ", 0h                           ;-- Captura o valor do ponto y2.------------------|
    textoQt db 0ah, "Digite a quantidade de furos: ", 0h                   ;-- Captura o valor da quantidade de furos.-------|
    IndicaX db 0ah, "Coordenada x: "                                       ;-- Imprime os valores intermediarios X.----------|
    IndicaY db 0ah, "Coordenada y: "                                       ;-- Imprime os valores intermediarios Y.----------|
    IndicaPos db 0h, " -->Furo: ", 0h                                      ;-- Imprime a posição de cada furo intermédiario.-|
    textoReinic db 0ah, "Deseja calcular uma nova sequencia? (s/n)", 0h    ;-- Imprime a opção de nova operação.-------------|
    
    ;---------------------- VARIAVEIS -----------------------|

    x1 real8 0.0         ;-- Armazena o valor de x1 em uma variavel do tipo float.----------|
    x2 real8 0.0         ;-- Armazena o valor de x2 em uma variavel do tipo float.----------|
    y1 real8 0.0         ;-- Armazena o valor de y1 em uma variavel do tipo float.----------|
    y2 real8 0.0         ;-- Armazena o valor de y2 em uma variavel do tipo float.----------|
    Quant real8 0.0      ;-- Armazena o valor de Quant em uma variavel do tipo float.-------|
    QuantVar real8 0.0   ;-- Armazena o valor da quant de furos entre (x1,y1) e (x2,y2).----|
    Carrapato1 real8 2.0 ;-- Var auxiliar para calcular o valor de QuantVar.----------------|
    Carrapato2 real8 1.0 ;-- Var auxiliar para calcular o valor da distancia entre pontos.--|
    Carrapato3 real8 0.0 ;-- Var auxiliar para calcular o valor x e y de cada ponto. -------|
    PosFuro real8 1.0    ;-- Var auxiliar que armazena a posição dos furos intermediarios.--|
    
    Carrapato5 dd ?          ;-- Vai receber Strlen de carrapato4. -------------------------|
    Ciclo real8 1.0          ;-- Vai armazenar o valor da iteração do loop. ----------------|
    
    DistanciaTotalX real8 0.0       ;-- Armazena o valor da distancia total no eixo X (distancia entre x1 e x2).--|
    DistanciaEntrePontosX real8 0.0 ;-- Armazena o valor da distancia entre cada ponto no eixo X -----------------|
    
    DistanciaTotalY real8 0.0       ;-- Armazena o valor da distancia total no eixo Y (distancia entre y1 e y2).--|
    DistanciaEntrePontosY real8 0.0 ;-- Armazena o valor da distancia entre cada ponto no eixo Y -----------------|

    Carrapato4 db 10 dup (?)  ;------ Armazena o valor de Carrapato3 em forma de string. -------------------------|
    Stringx1 db 10 dup (?)    ;------ Armazena o valor de entrada do console para x1 inicialmente como String.----| 
    Stringx2 db 10 dup (?)    ;------ Armazena o valor de entrada do console para x2 inicialmente como String.----| 
    Stringy1 db 10 dup (?)    ;------ Armazena o valor de entrada do console para y1 inicialmente como String.----| 
    Stringy2 db 10 dup (?)    ;------ Armazena o valor de entrada do console para y2 inicialmente como String.----| 
    StringQuant db 10 dup(?)  ;------ Armazena o valor de entrada do console para Quant inicialmente como String.-|  
    StringReinic db 10 dup(?) ;------ Armazena a resposta (s/n). -------------------------------------------------|
    PosFuroStr db 10 dup(?)   ;-----

    output_count dword ?      ;------ Armazena a quantidade de bytes nas strings de saída ------------------------|
    input_count dword ?       ;------ Armazena a quantidade de bytes das strings de entrada ----------------------|
    consoleOutHandle dword ?  ;------ Armazena os valores do Handle de saída. ------------------------------------|
    consoleInHandle dword ?   ;------ Armazena os valores do HAndle de entrada. ----------------------------------|
    
    
    ;--------------------------  CODE ----------------------------|    

.code
start:


    invoke GetStdHandle, STD_OUTPUT_HANDLE  ; ----------- imprimir no console, Get..=identificador, STD...=parametro --------------|
    mov consoleOutHandle, eax               ; ----------- Move o conteúdo de eax para consoleOutHandle ----------------------------|

    invoke GetStdHandle, STD_INPUT_HANDLE   ; ----------------------------- Capturar do teclado -----------------------------------|                          
    mov consoleInHandle, eax                ;----------- Move o conteúdo de eax para consoInHandle --------------------------------|


    ;-=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--
    ;                                                         INSERÇÃO DOS DADOS
    ;-=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--



    invoke WriteConsole, consoleOutHandle, addr textox1, sizeof textox1, addr output_count, NULL    ;--- Escreve no console textox1.--------------------------|
    invoke ReadConsole, consoleInHandle, addr Stringx1, sizeof Stringx1, addr input_count, NULL     ;--- Armazena na Stringx1 o valor de entrada no console.--|

    invoke StrToFloat, addr [Stringx1], addr [x1]   ;--------------------------------------------------- Converte o valor de Stringx1 para float.-------------|

    invoke WriteConsole, consoleOutHandle, addr textox2, sizeof textox2, addr output_count, NULL    ;--- Escreve no console textox2.--------------------------|
    invoke ReadConsole, consoleInHandle, addr Stringx2, sizeof Stringx2, addr input_count, NULL     ;--- Armazena na Stringx2 o valor de entrada no console.--|

    invoke StrToFloat, addr [Stringx2], addr [x2]   ;--------------------------------------------------- Converte o valor de Stringx2 para float.-------------|

    invoke WriteConsole, consoleOutHandle, addr textoy1, sizeof textoy1, addr output_count, NULL    ;--- Escreve no console textoy1.--------------------------|
    invoke ReadConsole, consoleInHandle, addr Stringy1, sizeof Stringy1, addr input_count, NULL     ;--- Armazena na Stringy1 o valor de entrada no console.--|

    invoke StrToFloat, addr [Stringy1], addr [y1]   ;--------------------------------------------------- Converte o valor de Stringy1 para float.-------------|

    invoke WriteConsole, consoleOutHandle, addr textoy2, sizeof textoy2, addr output_count, NULL    ;--- Escreve no console textoy2.--------------------------|
    invoke ReadConsole, consoleInHandle, addr Stringy2, sizeof Stringy2, addr input_count, NULL     ;--- Armazena na Stringy2 o valor de entrada no console.--|

    invoke StrToFloat, addr [Stringy2], addr [y2]   ;--------------------------------------------------- Converte o valor de Stringy2 para float.-------------|

    invoke WriteConsole, consoleOutHandle, addr textoQt, sizeof textoQt, addr output_count, NULL       ; Escreve no console textoy2.--------------------------|
    invoke ReadConsole, consoleInHandle, addr StringQuant, sizeof StringQuant, addr input_count, NULL  ; Armazena na Stringy2 o valor de entrada no console.--|

    invoke StrToFloat, addr [StringQuant], addr [Quant]   ;--------------------------------------------- Converte o valor de Stringy2 para float.-------------|



    ;-=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=
    ;                                                        CALCULO DAS DISTANCIAS.
    ;-=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=



    finit  ;----- Inicia a pilha com o valor zero ----|

    fld Quant               ;----- Adiciona a variavel Quant na pilha da FPU na posição st(0). ---------------------------------------|
    fld Carrapato1          ;----- Adiciona a variavel Carrapato1 na pilha do FPU na posição st(0), empurrando Quant para st(1). -----|
    fsub                    ;----- subtrai o conteúdo st(0) de st(1).  -> (Quant - Carrapato1). | logo, st(0) = st(1) - st(0). -------|
    fstp QuantVar           ;----- Desempilha o valor de st(0) e atribui a QuantVar --------------------------------------------------|
    finit                   ;----- Zera a pilha. -------------------------------------------------------------------------------------|

    fld x2                  ;----- Adiciona a variavel x2 a pilha da FPU na posição st(0). -------------------------------------------|
    fld x1                  ;----- Adiciona a variavel x1 a pilha da FPU na posição st(0), empurando x2 para st(1).-------------------|
    fsub                    ;----- Calcula a distancia entre o furo final e o furo inicial no eixo X. --------------------------------|
    fstp DistanciaTotalX    ;----- Armazena esse valor na variavel DistanciaTotalX. --------------------------------------------------|
    finit

    fld y2                  ;----- Adiciona a variavel y2 a pilha da FPU na posição st(0). -------------------------------------------| 
    fld y1                  ;----- Adiciona a variavel y1 a pilha da FPU na posição st(0), empurando y2 para st(1).-------------------|
    fsub                    ;----- Calcula a distancia entre o furo final e o furo inicial no eixo Y.---------------------------------|
    fstp DistanciaTotalY    ;----- Armazena esse valor na variavel DistanciaTotalY.---------------------------------------------------|
    finit                   ;----- Zera a pilha.--------------------------------------------------------------------------------------|

    fld Quant               ;----- Adiciona a variavel Quant a pilha da FPU na posição st(0). ----------------------------------------|
    fld Carrapato2          ;----- Adiciona a variavel Carrapato2 a pilha da FPU na posição st(0), empurrando Quant para st(1)--------|
    fsub                    ;----- Subtrai o valor 1 de Quant e armazena em Carrapato2 para termos o valor correspondente a...--------|
    fstp Carrapato2         ;----- ...quantidade de espaços entre furos no eixo X. ---------------------------------------------------|
    fld DistanciaTotalX     ;----- Adiciona a DistanciaTotalX na pilha da FPU.--------------------------------------------------------|
    fld Carrapato2          ;----- Adiciona Carrapato2 na pilha da FPU.---------------------------------------------------------------|
    fdiv                    ;----- Divide a distancia total entre furos no eixo X pela quantidade de espaços entre furos achando...---|
    fstp DistanciaEntrePontosX     ;- ...assim a distancia entre cada furo no eixo X. ------------------------------------------------|
    finit                   ;------------------------------------------ Zera a pilha -------------------------------------------------|

    fld Carrapato2          ;---------------------------------------------------------------------------------------------------------|
    fld Carrapato2          ;---------------------------------------------------------------------------------------------------------|
    fdiv                    ;-------------- Dividindo carrapato por si mesmo para retornar a ele o valor 1. --------------------------|
    fstp Carrapato2         ;---------------------------------------------------------------------------------------------------------|
    finit                   ;---------------------------------------------------------------------------------------------------------|
    
    fld Quant               ;------------------ Mesmo procedimento feito no eixo X é feito no eixo y ---------------------------------|
    fld Carrapato2
    fsub                    ;----- Subtrai o valor 1 de Quant e armazena em Carrapato2 para termos o valor correspondente a...--------|
    fstp Carrapato2         ;----------------------- ...quantidade de espaços entre furos no eixo Y. ---------------------------------|
    fld DistanciaTotalY
    fld Carrapato2
    fdiv                    ;----- Divide a distancia total entre furos no eixo Y pela quantidade de espaços entre furos achando...---|
    fstp DistanciaEntrePontosY   ;- ...assim a distancia entre cada furo no eixo Y. --------------------------------------------------|
    finit                   ;------------------------------------------ Zera a pilha -------------------------------------------------|

    fld Carrapato2          ;---------------------------------------------------------------------------------------------------------|
    fld Carrapato2          ;---------------------------------------------------------------------------------------------------------|
    fdiv                    ;-------------- Dividindo carrapato por si mesmo para retornar a ele o valor 1. --------------------------|
    fstp Carrapato2         ;---------------------------------------------------------------------------------------------------------|
    finit                   ;---------------------------------------------------------------------------------------------------------|
    
    ;-=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=
    ;                                                       CALCULO DOS FUROS
    ;-=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=-=-=--=-=

LACO:

    finit                   ;-------------------------------- Inicia a FPU com valores 0 ---------------------------------------------|

    fld PosFuro             ;---------------------------------------------------------------------------------------------------------|
    fld Carrapato2          ;---------------------------------------------------------------------------------------------------------|
    fadd                    ;-------------------------------- Incrementa o valor de PosFuro em 1 -------------------------------------|
    fstp PosFuro            ;---------------------------------------------------------------------------------------------------------|
    finit                   ;---------------------------------------------------------------------------------------------------------|
    invoke FloatToStr, [PosFuro], addr [PosFuroStr]     ;---- Converte PosFuro na string PosFuroStr ----------------------------------|
    
    fld Ciclo                   ;-----------------------------------------------------------------------------------------------------|
    fld DistanciaEntrePontosX   ;--------- [X do ponto atual = X inicial + (posição do ponto atual * distancia entre cada ponto)].----|
    fmul                        ;------------- Multiplica valor do Ciclo pela Distancia entre cada furo no eixo X e... ---------------|
    fld x1                      ;-------------...Soma com o valor do X inicial... ----------------------------------------------------|
    fadd                        ;-------------...Calculando o valor da coordenada X do furo em cada nova iteração do Ciclo... --------|
    fstp Carrapato3             ;-------------...E armazena esse valor em Carrapato3 . -----------------------------------------------|
    finit                       ;-----------------------------------------------------------------------------------------------------|

    invoke FloatToStr, [Carrapato3], addr [Carrapato4]    ;------ Converte Carrapato 3 para uma string Carrapato4. -------------------|
    invoke StrLen, addr [Carrapato4]                      ;------ Calcula o comprimento de Carrapato4 (valor vai para eax). ----------|
    mov Carrapato5, eax                                   ;------ Move o valor do comprimento de Carrapato4 para Carrapato5. ---------| 

    invoke WriteConsole, consoleOutHandle, addr IndicaX, sizeof IndicaX, addr output_count, NULL       ;---- Imprime IndicaX.---------|
    invoke WriteConsole, consoleOutHandle, addr Carrapato4, Carrapato5, addr output_count, NULL        ;---- Imprime Carrapato4.------|
    invoke WriteConsole, consoleOutHandle, addr IndicaPos, sizeof IndicaPos, addr output_count, NULL   ;---- Imprime IndicaPos.-------|
    invoke WriteConsole, consoleOutHandle, addr PosFuroStr, sizeof PosFuroStr, addr output_count, NULL ;---- Imprime PosFuroStr.------|

    fld Ciclo                   ;-----------------------------------------------------------------------------------------------------|
    fld DistanciaEntrePontosY   ;--------- [Y do ponto atual = Y inicial + (posição do ponto atual * distancia entre cada ponto)].----|
    fmul                        ;------------- Multiplica valor do Ciclo pela Distancia entre cada furo no eixo y e... ---------------|
    fld y1                      ;-------------...Soma com o valor do y inicial... ----------------------------------------------------|
    fadd                        ;-------------...Calculando o valor da coordenada y do furo em cada nova iteração do Ciclo... --------|
    fstp Carrapato3             ;-------------...E armazena esse valor em Carrapato3 . -----------------------------------------------|
    finit                       ;-----------------------------------------------------------------------------------------------------|

    invoke FloatToStr, [Carrapato3], addr [Carrapato4]    ;------ Converte Carrapato 3 para uma string Carrapato4. -------------------|
    invoke StrLen, addr [Carrapato4]                      ;------ Calcula o comprimento de Carrapato4 (valor vai para eax). ----------|                       
    mov Carrapato5, eax                                   ;------ Move o valor do comprimento de Carrapato4 para Carrapato5. ---------|

    invoke WriteConsole, consoleOutHandle, addr IndicaY, sizeof IndicaY, addr output_count, NULL        ;---- Imprime IndicaY.--------|
    invoke WriteConsole, consoleOutHandle, addr Carrapato4, Carrapato5, addr output_count, NULL         ;---- Imprime Carrapato4.-----|
    invoke WriteConsole, consoleOutHandle, addr IndicaPos, sizeof IndicaPos, addr output_count, NULL    ;---- Imprime IndicaPos.------|
    invoke WriteConsole, consoleOutHandle, addr PosFuroStr, sizeof PosFuroStr, addr output_count, NULL  ;---- Imprime PosFuroStr.-----|
    
     
    fld QuantVar                ;-----------------------------------------------------------------------------------------------------|
    fld Ciclo                   ;-----------------------------------------------------------------------------------------------------|
    fcom                        ;------- Compara o valor do Ciclo atual com QuantVar (que guarda o valor de pontos intermediarios). --|     
    fstsw ax                    ;------- Atualiza as flags da ULA de acordo com as flags da FPU. -------------------------------------|
    fwait                       ;------- Espera pela atualização das flags antes de fazer uma nova operação. -------------------------|
    sahf                        ;-----------------------------------------------------------------------------------------------------|
    finit

    fld Ciclo                   ;-----------------------------------------------------------------------------------------------------|
    fld Carrapato2              ;-----------------------------------------------------------------------------------------------------|
    fadd                        ;--------------- Incrementa o valor de Ciclo em 1. ---------------------------------------------------|
    fstp Ciclo                  ;-----------------------------------------------------------------------------------------------------|

    jb LACO                     ;------ Caso a comparação anterior indicar que ciclo é menor que QuantVar, pule pro inicio do laço. --|

    fld Ciclo                   ;-----------------------------------------------------------------------------------------------------|
    fld Ciclo                   ;-----------------------------------------------------------------------------------------------------|
    fdiv                        ;------- Divide Ciclo por ele mesmo o retornando ao valor 1. -----------------------------------------|
    fstp Ciclo                  ;-----------------------------------------------------------------------------------------------------|
    finit                       ;-----------------------------------------------------------------------------------------------------|

    fld PosFuro                 ;-----------------------------------------------------------------------------------------------------|
    fld PosFuro                 ;-----------------------------------------------------------------------------------------------------|
    fdiv                        ;------- Divide PosFuro por ele mesmo o retornando ao valor 1. ---------------------------------------|
    fstp PosFuro                ;-----------------------------------------------------------------------------------------------------|
    finit                       ;-----------------------------------------------------------------------------------------------------|

RESTART:
    invoke WriteConsole, consoleOutHandle, addr textoReinic, sizeof textoReinic, addr output_count, NULL ;---- Imprime textoReinic.-----------|
    invoke ReadConsole, consoleInHandle, addr StringReinic, sizeof StringReinic, addr input_count, NULL  ;---- Captura a Resposta do Usuario.-|

   cmp StringReinic, 73h        ;------- Compara StringReinic com o caracter "s". ----------------------------------------------------|
    je start                    ;------- Caso StringReinic for igual a "s", o programa volta ao inicio. ------------------------------|
    cmp StringReinic, 6eh       ;------- Compara StringReinic com o caracter "n". ----------------------------------------------------|
    je FINITE                   ;------- Caso StringReinic for igual a "n", o programa finaliza. -------------------------------------|
    jmp RESTART                 ;------- Caso StringReinic não for igual nem a "s" nem a "n", executa novamente o RESTART. -----------|

FINITE:    
     invoke ExitProcess, 0      ;------- Finaliza o processo. ------------------------------------------------------------------------|
end start