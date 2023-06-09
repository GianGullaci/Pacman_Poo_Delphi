program Pacman;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Math,
  LO_Pacman in 'LO_Pacman.pas',
  Velthuis.Console in 'Velthuis.Console.pas';

var
  Juego_Pacman: oTipo_Juego_Pacman;
  cModo_Juego: Char;
  Coord_Actual,Coord_Nueva: Tipo_Coord;


//--------------------------------------------------------------
//Opcion modo de juego
Function Modo_Juego: Char ;
Var
 cCar : Char ;
begin
	 repeat
		cCar:= UpCase ( Readkey ) ;
	 until (cCar = 'M') or (cCar = 'A') or (cCar = #27);
	 Result:= cCar ;
end ;


//--------------------------------------------------------------
//Movimiento del usuario
Function Movimiento_Manual: Char ;
Var
 cCar : Char ;
begin
	 repeat
		cCar:= UpCase ( Readkey ) ;
	 until (cCar = 'W') or (cCar = 'A') or (cCar = 'D') or (cCar = 'X') or (cCar = 'Q') or (cCar = 'E') or (cCar = 'Z') or (cCar = 'C');
	 Result:= cCar ;
end ;


//--------------------------------------------------------------
//Movimiento aleatorio
Function Movimiento_Aleatorio: Char ;
Var
  cCar: Char;
  w_Op: word;
  b_Mueve: boolean;
begin
  randomize;
  cCar:= ' ';
  b_Mueve:= false;
	 repeat
    w_op:= random(80) div 10;
    case w_Op of
      0:begin
          cCar:= 'W';
          b_Mueve:= true;
        end;
      1:begin
          cCar:= 'X';
          b_Mueve:= true;
        end;
      2:begin
          cCar:= 'D';
          b_Mueve:= true;
        end;
      3:begin
          cCar:= 'A';
          b_Mueve:= true;
        end;
      4:begin
          cCar:= 'E';
          b_Mueve:= true;
        end;
      5:begin
          cCar:= 'Q';
          b_Mueve:= true;
        end;
      6:begin
          cCar:= 'C';
          b_Mueve:= true;
        end;
      7:begin
          cCar:= 'Z';
          b_Mueve:= true;
        end;
    end;
	 until b_Mueve = True;
	 Result:= cCar ;
end ;


//--------------------------------------------------------------
//Mostrar mensaje
Procedure Mostrar_Mensaje (byFila, byColu: byte; sTexto: string);
begin
  gotoxy (byColu, byFila);
  write (sTexto);
end;


//--------------------------------------------------------------
//Mostrar men� principal
Procedure Menu_Principal;
begin
  Mostrar_Mensaje (2, 33, 'BIENVENIDO AL JUEGO PACMAN');
  Mostrar_Mensaje (4, 35, 'Elija el modo de juego');
  Mostrar_Mensaje (6, 27, 'M: Modo Manual');
  Mostrar_Mensaje (6, 47, 'A: Modo Automatico');
end;


//--------------------------------------------------------------
//Mostrar matriz de juego
Procedure Mostrar_Escenario;
var
  Coord_Actual, Coord_Ultimo: Tipo_Coord;
  elemento: Tipo_Elemento;
begin
  Mostrar_Mensaje (2, 33, 'BIENVENIDO AL JUEGO PACMAN');
  Mostrar_Mensaje (28, 10, Juego_Pacman.Hora_Comienzo);
  gotoxy(10,25);
  ClrEol;
  Mostrar_Mensaje (25, 10, 'Manzanas restantes: ' + FloatToStr(Juego_Pacman.Manzana.Manzanas));
  gotoxy(10,26);
  ClrEol;
  Mostrar_Mensaje (26, 10, 'Puntos: ' + FloatToStr(Juego_Pacman.Pacman.Cant_Puntos));
  gotoxy(10,27);
  ClrEol;
  Mostrar_Mensaje (27, 10, 'Vidas: ' + FloatToStr(Juego_Pacman.Pacman.Cant_Vidas));


  Coord_Actual:= Juego_Pacman.Primero;
  Coord_Ultimo:= Juego_Pacman.Ultimo;
  repeat
    Gotoxy (Coord_Actual.Colu + 10, Coord_Actual.Fila + 3);
    elemento:= Juego_Pacman.Estado_Casillero(Coord_Actual);
    write(elemento);
    Coord_Actual:= Juego_Pacman.Proximo(Coord_Actual);
  until (Coord_Actual.Fila = Coord_Ultimo.Fila) and (Coord_Actual.Colu = Coord_Ultimo.Colu);
end;


//--------------------------------------------------------------
//Mensaje sobre los controles de forma manual
Procedure Controles_Manual;
begin
  Mostrar_Mensaje (4, 94, 'Controles de juego');
  Mostrar_Mensaje (5, 90, 'W: Arriba');
  Mostrar_Mensaje (6, 90, 'X: Abajo');
  Mostrar_Mensaje (7, 90, 'D: Derecha');
  Mostrar_Mensaje (8, 90, 'A: Izquierda');
  Mostrar_Mensaje (9, 90, 'E: Diagonal Arriba-Derecha');
  Mostrar_Mensaje (10, 90, 'Q: Diagonal Arriba-Izquierda');
  Mostrar_Mensaje (11, 90, 'C: Diagonal Abajo-Derecha');
  Mostrar_Mensaje (12, 90, 'Z: Diagonal Abajo-Izquierda');
end;


//--------------------------------------------------------------
//Mensaje fin de juego si gan�
Procedure Mensaje_Gano;
begin
  repeat
    Mostrar_Mensaje (4, 33, 'FELICITACIONES!!! GANASTE!!!');
    Mostrar_Mensaje (6, 40, 'Puntaje: ' + FloatToStr(Juego_Pacman.Pacman.Cant_Puntos));
    Mostrar_Mensaje (8, 36, 'Veces Capturado: ' + FloatToStr(Juego_Pacman.Pacman.Cant_Capturado));
    Mostrar_Mensaje (10, 40, 'ESC: Salir');
  until ReadKey = #27;
end;


//--------------------------------------------------------------
//Mensaje fin de juego si perdi�
Procedure Mensaje_Perdio;
begin
  repeat
    Mostrar_Mensaje (4, 33, 'LAMENTABLEMENTE HAS PERDIDO');
    Mostrar_Mensaje (6, 40, 'Puntaje: ' + FloatToStr(Juego_Pacman.Pacman.Cant_Puntos));
    Mostrar_Mensaje (8, 36, 'Veces Capturado: ' + FloatToStr(Juego_Pacman.Pacman.Cant_Capturado));
    Mostrar_Mensaje (10, 40, 'ESC: Salir');
  until ReadKey = #27;
end;


//-------------------------------------------------------------
//Finaliza el juego
Function Fin_Juego: Boolean;
begin
  Result:=(Juego_Pacman.Manzana.Manzanas=0) or (Juego_Pacman.Pacman.Cant_Vidas=0);
end;


//--------------------------------------------------------------
//Movimiento aleatorio fantasma y evalua si come al pacman
Procedure Mover_Fantasma_Aleatorio_Come;
var
  w_Op: word;
  b_Mueve, b_Come: boolean;
begin
  randomize;
  b_Mueve:= False;
  b_Come:= False;
  repeat
    w_Op:= random(80) div 10;
    case w_Op of
      0:begin
          Coord_Nueva.Fila:= pred(Juego_Pacman.Fantasma.Coordenadas.Fila);
          Coord_Nueva.Colu:=(Juego_Pacman.Fantasma.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
              or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
            begin
              if Juego_Pacman.Fantasma.Arriba(Coord_Actual,Coord_Nueva) then
                begin
                  Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                  if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman) then
                    b_Come:= true;
                  b_Mueve:= True;
                end;
            end;
        end;
      1:begin
          Coord_Nueva.Fila:= succ(Juego_Pacman.Fantasma.Coordenadas.Fila);
          Coord_Nueva.Colu:=(Juego_Pacman.Fantasma.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
              or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
            begin
              if Juego_Pacman.Fantasma.Abajo(Coord_Actual,Coord_Nueva) then
                begin
                  Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                  if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman) then
                    b_Come:= true;
                  b_Mueve:= True;
                end;
            end;
        end;
      2:begin
          Coord_Nueva.Fila:= (Juego_Pacman.Fantasma.Coordenadas.Fila);
          Coord_Nueva.Colu:=succ(Juego_Pacman.Fantasma.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
              or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
            begin
              if Juego_Pacman.Fantasma.Derecha(Coord_Actual,Coord_Nueva) then
                begin
                  Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                  if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman) then
                    b_Come:= true;
                  b_Mueve:= True;
                end;
            end;
        end;
      3:begin
          Coord_Nueva.Fila:= (Juego_Pacman.Fantasma.Coordenadas.Fila);
          Coord_Nueva.Colu:= pred(Juego_Pacman.Fantasma.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
              or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
            begin
              if Juego_Pacman.Fantasma.Izquierda(Coord_Actual,Coord_Nueva) then
                begin
                  Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                  if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman) then
                    b_Come:= true;
                  b_Mueve:= True;
                end;
            end;
        end;
      4:begin
          Coord_Nueva.Fila:= pred(Juego_Pacman.Fantasma.Coordenadas.Fila);
          Coord_Nueva.Colu:= succ(Juego_Pacman.Fantasma.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
              or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
            begin
              if Juego_Pacman.Fantasma.Arriba_Derecha(Coord_Actual,Coord_Nueva) then
                begin
                  Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                  if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman) then
                    b_Come:= true;
                  b_Mueve:= True;
                end;
            end;
        end;
      5:begin
          Coord_Nueva.Fila:= pred(Juego_Pacman.Fantasma.Coordenadas.Fila);
          Coord_Nueva.Colu:= pred(Juego_Pacman.Fantasma.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
              or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
            begin
              if Juego_Pacman.Fantasma.Arriba_Izquierda(Coord_Actual,Coord_Nueva) then
                begin
                  Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                  if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman) then
                    b_Come:= true;
                  b_Mueve:= True;
                end;
            end;
        end;
      6:begin
          Coord_Nueva.Fila:= succ(Juego_Pacman.Fantasma.Coordenadas.Fila);
          Coord_Nueva.Colu:= succ(Juego_Pacman.Fantasma.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
              or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
            begin
              if Juego_Pacman.Fantasma.Abajo_Derecha(Coord_Actual,Coord_Nueva) then
                begin
                  Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                  if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman) then
                    b_Come:= true;
                  b_Mueve:= True;
                end;
            end;
        end;
      7:begin
          Coord_Nueva.Fila:= succ(Juego_Pacman.Fantasma.Coordenadas.Fila);
          Coord_Nueva.Colu:= pred(Juego_Pacman.Fantasma.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
              or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
            begin
              if Juego_Pacman.Fantasma.Abajo_Izquierda(Coord_Actual,Coord_Nueva) then
                begin
                  Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                  if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman) then
                    b_Come:= true;
                  b_Mueve:= True;
                end;
            end;
        end;
    end;
  until (b_Mueve = True) or (b_Come = True);
  if b_Come = true then
    begin
      Juego_Pacman.Pacman.Pierde_Vida;
      Juego_Pacman.Actualizo_Capturado;
    end;
end;


//--------------------------------------------------------------
//Movimiento del fantasma persiguiendo el pacman y evalua si lo come
Procedure Mover_Fantasma_Acercando_Come;
var
  s_Fila: shortint;
  s_Colu: shortint;
  i: Tipo_Rango_Fila;
  j: Tipo_Rango_Colu;
  b_Come, b_Mueve: Boolean;
begin
  b_Come:= false;
  s_Fila:= Juego_Pacman.Fantasma.Coordenadas.Fila - Juego_Pacman.Pacman.Coordenadas.Fila;
  s_Colu:= Juego_Pacman.Fantasma.Coordenadas.Colu - Juego_Pacman.Pacman.Coordenadas.Colu;

  for i:= pred(Juego_Pacman.Fantasma.Coordenadas.Fila) to succ(Juego_Pacman.Fantasma.Coordenadas.Fila) do
    for j:= pred(Juego_Pacman.Fantasma.Coordenadas.Colu) to succ(Juego_Pacman.Fantasma.Coordenadas.Colu) do
      begin
        Coord_Actual.Fila:= i;
        Coord_Actual.Colu:= j;
        if Juego_Pacman.Estado_Casillero(Coord_Actual) = Juego_Pacman.Pacman.Simbolo_Pacman then
          b_Come:= true;
      end;

  if b_Come = false then
    begin
      b_Mueve:= false;
      repeat
        if ((s_Fila < 0) and (s_Colu < 0)) then
          begin
            Coord_Nueva.Fila:= succ(Juego_Pacman.Fantasma.Coordenadas.Fila);
            Coord_Nueva.Colu:= succ(Juego_Pacman.Fantasma.Coordenadas.Colu);
            if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
                or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
              begin
                Juego_Pacman.Fantasma.Abajo_Derecha(Coord_Actual,Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  b_Come:= true;
                b_Mueve:= True;
              end
            else
              begin
                Mover_Fantasma_Aleatorio_Come;
                b_Mueve:= true;
              end;
          end;
        if ((s_Fila < 0) and (s_Colu > 0)) then
          begin
            Coord_Nueva.Fila:= succ(Juego_Pacman.Fantasma.Coordenadas.Fila);
            Coord_Nueva.Colu:= pred(Juego_Pacman.Fantasma.Coordenadas.Colu);
            if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
                or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
              begin
                Juego_Pacman.Fantasma.Abajo_Izquierda(Coord_Actual,Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  b_Come:= true;
                b_Mueve:= True;
              end
            else
              begin
                Mover_Fantasma_Aleatorio_Come;
                b_Mueve:= true;
              end;
          end;
        if ((s_Fila < 0) and (s_Colu = 0)) then
          begin
            Coord_Nueva.Fila:= succ(Juego_Pacman.Fantasma.Coordenadas.Fila);
            Coord_Nueva.Colu:= Juego_Pacman.Fantasma.Coordenadas.Colu;
            if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
                or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
              begin
                Juego_Pacman.Fantasma.Abajo(Coord_Actual,Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  b_Come:= true;
                b_Mueve:= True;
              end
            else
              begin
                Mover_Fantasma_Aleatorio_Come;
                b_Mueve:= true;
              end;
          end;
        if ((s_Fila > 0) and (s_Colu < 0)) then
          begin
            Coord_Nueva.Fila:= pred(Juego_Pacman.Fantasma.Coordenadas.Fila);
            Coord_Nueva.Colu:= succ(Juego_Pacman.Fantasma.Coordenadas.Colu);
            if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
                or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
              begin
                Juego_Pacman.Fantasma.Arriba_Derecha(Coord_Actual,Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  b_Come:= true;
                b_Mueve:= True;
              end
            else
              begin
                Mover_Fantasma_Aleatorio_Come;
                b_Mueve:= true;
              end;
          end;
        if ((s_Fila > 0) and (s_Colu > 0)) then
          begin
            Coord_Nueva.Fila:= pred(Juego_Pacman.Fantasma.Coordenadas.Fila);
            Coord_Nueva.Colu:= pred(Juego_Pacman.Fantasma.Coordenadas.Colu);
            if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
                or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
              begin
                Juego_Pacman.Fantasma.Arriba_Izquierda(Coord_Actual,Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  b_Come:= true;
                b_Mueve:= True;
              end
            else
              begin
                Mover_Fantasma_Aleatorio_Come;
                b_Mueve:= true;
              end;
          end;
        if ((s_Fila > 0) and (s_Colu = 0)) then
          begin
            Coord_Nueva.Fila:= pred(Juego_Pacman.Fantasma.Coordenadas.Fila);
            Coord_Nueva.Colu:= Juego_Pacman.Fantasma.Coordenadas.Colu;
            if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
                or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
              begin
                Juego_Pacman.Fantasma.Arriba(Coord_Actual,Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  b_Come:= true;
                b_Mueve:= True;
              end
            else
              begin
                Mover_Fantasma_Aleatorio_Come;
                b_Mueve:= true;
              end;
          end;
        if ((s_Fila = 0) and (s_Colu < 0)) then
          begin
            Coord_Nueva.Fila:= Juego_Pacman.Fantasma.Coordenadas.Fila;
            Coord_Nueva.Colu:= succ(Juego_Pacman.Fantasma.Coordenadas.Colu);
            if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
                or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
              begin
                Juego_Pacman.Fantasma.Derecha(Coord_Actual,Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  b_Come:= true;
                b_Mueve:= True;
              end
            else
              begin
                Mover_Fantasma_Aleatorio_Come;
                b_Mueve:= true;
              end;
          end;
        if ((s_Fila = 0) and (s_Colu > 0)) then
          begin
            Coord_Nueva.Fila:= Juego_Pacman.Fantasma.Coordenadas.Fila;
            Coord_Nueva.Colu:= pred(Juego_Pacman.Fantasma.Coordenadas.Colu);
            if (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman)
                or (Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Vacio.Simbolo_Vacio) then
              begin
                Juego_Pacman.Fantasma.Izquierda(Coord_Actual,Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Fantasma.Simbolo_Fantasma);
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  b_Come:= true;
                b_Mueve:= True;
              end
            else
              begin
                Mover_Fantasma_Aleatorio_Come;
                b_Mueve:= true;
              end;
          end;
      until (b_Mueve = True) or (b_Come = True);
    end;

  if b_Come = true then
    begin
      Juego_Pacman.Pacman.Pierde_Vida;
      Juego_Pacman.Actualizo_Capturado;
    end;
end;



//--------------------------------------------------------------
//Limpiar Pantalla
Procedure Limpiar_Pantalla ();
begin
  clrScr;
end;



//--------------------------------------------------------------
//Eliminar manzanas al explotar bomba
Procedure Eliminar_Manzanas (Coord_Nueva_Pacman: Tipo_Coord);
var
  i: Tipo_Rango_Fila;
  j: Tipo_Rango_Colu;
  Coord: Tipo_Coord;
begin
  for i:= Coord_Nueva_Pacman.Fila - 1 to Coord_Nueva_Pacman.Fila + 1 do
    for j:= Coord_Nueva_Pacman.Colu - 1 to Coord_Nueva_Pacman.Colu + 1 do
      begin
        Coord.Fila:= i;
        Coord.Colu:= j;
        if Juego_Pacman.Estado_Casillero(Coord) = Juego_Pacman.Manzana.Simbolo_Manzana then
          begin
            Juego_Pacman.Ocupar_Casilla(Coord,Juego_Pacman.Vacio.Simbolo_Vacio);
            Juego_Pacman.Manzana.Restar_Manzana;
          end;
      end;
end;



//--------------------------------------------------------------
//Procedimiento del juego
Procedure Juego (cModo_Juego: char);
var
  cOpcionJugador: Char;
begin
  Mostrar_Escenario;
  Controles_Manual;

  repeat
    if cModo_Juego = 'M' then
      cOpcionJugador:= Movimiento_Manual
    else
      cOpcionJugador:= Movimiento_Aleatorio;

    case cOpcionJugador of
      'W':begin //Mover Arriba
          Coord_Nueva.Fila:= pred(Juego_Pacman.Pacman.Coordenadas.Fila);
          Coord_Nueva.Colu:= (Juego_Pacman.Pacman.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva)<>Juego_Pacman.Piedra.Simbolo_Piedra) then
           begin
            if (Juego_Pacman.Pacman.Arriba(Coord_Actual,Coord_Nueva)) then
              begin
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Manzana.Simbolo_Manzana then
                  Juego_Pacman.Pacman.Ganar_Puntos;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Bomba.Simbolo_Bomba then
                  Eliminar_Manzanas (Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Pacman.Simbolo_Pacman);
                Mover_Fantasma_Aleatorio_Come;
                Mostrar_Escenario;
                Delay(50);
                Mover_Fantasma_Acercando_Come;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  begin
                    Juego_Pacman.Pacman.Pierde_Vida;
                    Juego_Pacman.Actualizo_Capturado;
                  end;
                Mostrar_Escenario;
              end;
             end;
           end;
      'X':begin //Mover Abajo
          Coord_Nueva.Fila:= Succ(Juego_Pacman.Pacman.Coordenadas.Fila);
          Coord_Nueva.Colu:= (Juego_Pacman.Pacman.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva)<>Juego_Pacman.Piedra.Simbolo_Piedra) then
           begin
            if (Juego_Pacman.Pacman.Abajo(Coord_Actual,Coord_Nueva)) then
              begin
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Manzana.Simbolo_Manzana then
                  Juego_Pacman.Pacman.Ganar_Puntos;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Bomba.Simbolo_Bomba then
                  Eliminar_Manzanas (Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Pacman.Simbolo_Pacman);
                Mover_Fantasma_Aleatorio_Come;
                Mostrar_Escenario;
                Delay(50);
                Mover_Fantasma_Acercando_Come;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  begin
                    Juego_Pacman.Pacman.Pierde_Vida;
                    Juego_Pacman.Actualizo_Capturado;
                  end;
                Mostrar_Escenario;
              end;
             end;
           end;
      'D':begin //Mover Derecha
          Coord_Nueva.Fila:= (Juego_Pacman.Pacman.Coordenadas.Fila);
          Coord_Nueva.Colu:= succ(Juego_Pacman.Pacman.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva)<>Juego_Pacman.Piedra.Simbolo_Piedra) then
           begin
            if (Juego_Pacman.Pacman.Derecha(Coord_Actual,Coord_Nueva)) then
              begin
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Manzana.Simbolo_Manzana then
                  Juego_Pacman.Pacman.Ganar_Puntos;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Bomba.Simbolo_Bomba then
                  Eliminar_Manzanas (Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Pacman.Simbolo_Pacman);
                Mover_Fantasma_Aleatorio_Come;
                Mostrar_Escenario;
                Delay(50);
                Mover_Fantasma_Acercando_Come;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  begin
                    Juego_Pacman.Pacman.Pierde_Vida;
                    Juego_Pacman.Actualizo_Capturado;
                  end;
                Mostrar_Escenario;
              end;
             end;
           end;
      'A':begin //Mover Izquierda
          Coord_Nueva.Fila:= (Juego_Pacman.Pacman.Coordenadas.Fila);
          Coord_Nueva.Colu:= pred(Juego_Pacman.Pacman.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva)<>Juego_Pacman.Piedra.Simbolo_Piedra) then
           begin
            if (Juego_Pacman.Pacman.Izquierda(Coord_Actual,Coord_Nueva)) then
              begin
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Manzana.Simbolo_Manzana then
                  Juego_Pacman.Pacman.Ganar_Puntos;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Bomba.Simbolo_Bomba then
                  Eliminar_Manzanas (Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Pacman.Simbolo_Pacman);
                Mover_Fantasma_Aleatorio_Come;
                Mostrar_Escenario;
                Delay(50);
                Mover_Fantasma_Acercando_Come;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  begin
                    Juego_Pacman.Pacman.Pierde_Vida;
                    Juego_Pacman.Actualizo_Capturado;
                  end;
                Mostrar_Escenario;
              end;
             end;
           end;
      'E':begin //Mover Arriba-Derecha
          Coord_Nueva.Fila:= pred(Juego_Pacman.Pacman.Coordenadas.Fila);
          Coord_Nueva.Colu:= succ(Juego_Pacman.Pacman.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva)<>Juego_Pacman.Piedra.Simbolo_Piedra) then
           begin
            if (Juego_Pacman.Pacman.Arriba_Derecha(Coord_Actual,Coord_Nueva)) then
              begin
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Manzana.Simbolo_Manzana then
                  Juego_Pacman.Pacman.Ganar_Puntos;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Bomba.Simbolo_Bomba then
                  Eliminar_Manzanas (Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Pacman.Simbolo_Pacman);
                Mover_Fantasma_Aleatorio_Come;
                Mostrar_Escenario;
                Delay(50);
                Mover_Fantasma_Acercando_Come;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  begin
                    Juego_Pacman.Pacman.Pierde_Vida;
                    Juego_Pacman.Actualizo_Capturado;
                  end;
                Mostrar_Escenario;
              end;
             end;
           end;
      'Q':begin //Mover Arriba-Izquierda
          Coord_Nueva.Fila:= pred(Juego_Pacman.Pacman.Coordenadas.Fila);
          Coord_Nueva.Colu:= pred(Juego_Pacman.Pacman.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva)<>Juego_Pacman.Piedra.Simbolo_Piedra) then
           begin
            if (Juego_Pacman.Pacman.Arriba_Izquierda(Coord_Actual,Coord_Nueva)) then
              begin
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Manzana.Simbolo_Manzana then
                  Juego_Pacman.Pacman.Ganar_Puntos;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Bomba.Simbolo_Bomba then
                  Eliminar_Manzanas (Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Pacman.Simbolo_Pacman);
                Mover_Fantasma_Aleatorio_Come;
                Mostrar_Escenario;
                Delay(50);
                Mover_Fantasma_Acercando_Come;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  begin
                    Juego_Pacman.Pacman.Pierde_Vida;
                    Juego_Pacman.Actualizo_Capturado;
                  end;
                Mostrar_Escenario;
              end;
             end;
           end;
      'C':begin //Mover Abajo-Derecha
          Coord_Nueva.Fila:= Succ(Juego_Pacman.Pacman.Coordenadas.Fila);
          Coord_Nueva.Colu:= succ(Juego_Pacman.Pacman.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva)<>Juego_Pacman.Piedra.Simbolo_Piedra) then
           begin
            if (Juego_Pacman.Pacman.Abajo_Derecha(Coord_Actual,Coord_Nueva)) then
              begin
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Manzana.Simbolo_Manzana then
                  Juego_Pacman.Pacman.Ganar_Puntos;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Bomba.Simbolo_Bomba then
                  Eliminar_Manzanas (Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Pacman.Simbolo_Pacman);
                Mover_Fantasma_Aleatorio_Come;
                Mostrar_Escenario;
                Delay(50);
                Mover_Fantasma_Acercando_Come;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  begin
                    Juego_Pacman.Pacman.Pierde_Vida;
                    Juego_Pacman.Actualizo_Capturado;
                  end;
                Mostrar_Escenario;
              end;
             end;
           end;
      'Z':begin //Mover Abajo-Izquierda
          Coord_Nueva.Fila:= Succ(Juego_Pacman.Pacman.Coordenadas.Fila);
          Coord_Nueva.Colu:= pred(Juego_Pacman.Pacman.Coordenadas.Colu);
          if (Juego_Pacman.Estado_Casillero(Coord_Nueva)<>Juego_Pacman.Piedra.Simbolo_Piedra) then
           begin
            if (Juego_Pacman.Pacman.Abajo_Izquierda(Coord_Actual,Coord_Nueva)) then
              begin
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Manzana.Simbolo_Manzana then
                  Juego_Pacman.Pacman.Ganar_Puntos;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Bomba.Simbolo_Bomba then
                  Eliminar_Manzanas (Coord_Nueva);
                Juego_Pacman.Intercambio_Elementos(Coord_Actual,Coord_Nueva,Juego_Pacman.Pacman.Simbolo_Pacman);
                Mover_Fantasma_Aleatorio_Come;
                Mostrar_Escenario;
                Delay(50);
                Mover_Fantasma_Acercando_Come;
                if Juego_Pacman.Estado_Casillero(Coord_Nueva) = Juego_Pacman.Pacman.Simbolo_Pacman then
                  begin
                    Juego_Pacman.Pacman.Pierde_Vida;
                    Juego_Pacman.Actualizo_Capturado;
                  end;
                Mostrar_Escenario;
              end;
             end;
          end;
      end;
    until (Fin_Juego);
end;





//--------------------------------------------------------------
//Cuerpo principal del programa
begin
    Juego_Pacman:= oTipo_Juego_Pacman.Create;
    Juego_Pacman.Pacman:= oTipo_Pacman.Create;
    Juego_Pacman.Fantasma:= oTipo_Fantasma.Create;
    Juego_Pacman.Manzana:= oTipo_Manzana.Create;
    Juego_Pacman.Bomba:= oTipo_Bomba.Create;
    Juego_Pacman.Piedra:= oTipo_Piedra.Create;


    Menu_Principal;
    cModo_Juego:= Modo_Juego;
    Juego_Pacman.Crear;

    case cModo_Juego of
      'M':begin //Modo manual
            Limpiar_Pantalla;
            Juego(cModo_Juego);
            if Fin_Juego then
              begin
                Limpiar_Pantalla;
                if Juego_Pacman.Manzana.Manzanas=0 then
                  Mensaje_Gano
                else
                  Mensaje_Perdio;
                Juego_Pacman.Pacman.Free;
                Juego_Pacman.Fantasma.Free;
                Juego_Pacman.Manzana.Free;
                Juego_Pacman.Bomba.Free;
                Juego_Pacman.Piedra.Free;
                Juego_Pacman.Free;
              end;
          end;

      'A':begin //Modo Autom�tico
            Limpiar_Pantalla;
            Juego(cModo_Juego);
            if Fin_Juego then
              begin
                Limpiar_Pantalla;
                if Juego_Pacman.Manzana.Manzanas=0 then
                  Mensaje_Gano
                else
                  Mensaje_Perdio;
                Juego_Pacman.Pacman.Free;
                Juego_Pacman.Fantasma.Free;
                Juego_Pacman.Manzana.Free;
                Juego_Pacman.Bomba.Free;
                Juego_Pacman.Piedra.Free;
                Juego_Pacman.Free;
              end;
          end;
    end;

end.
