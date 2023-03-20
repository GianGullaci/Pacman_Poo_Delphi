unit LO_Pacman;

interface

uses
  SysUtils;

Const
  Cte_Ini = 1;
  Cte_Max_Fila = 20;
  Cte_Max_Colu = 70;
  Cte_Manzana = 'M';
  Cte_Pacman = 'C';
  Cte_Fantasma = 'F';
  Cte_Bomba = 'B';
  Cte_Piedra = 'O';
  Cte_Vacio = ' ';
  Cte_Valor_Manzana = 15;
  Cte_Cant_Manzanas = 10;
  Cte_Cant_Piedras = 200;
  Cte_Cant_Bombas = 15;
  Cte_Cant_Vidas = 3;
  Cte_Cant_Puntos = 0;
  Cte_Cant_Capturado = 0;

Type
  Tipo_Rango_Fila = Cte_Ini - 1 .. Cte_Max_Fila + 1;
  Tipo_Rango_Colu = Cte_Ini - 1 .. Cte_Max_Colu + 1;

  Tipo_Elemento = Char;

  Tipo_Coord = Record
                  Fila: Tipo_Rango_Fila;
                  Colu: Tipo_Rango_Colu;
                end;

  Tipo_Matriz = Array [Tipo_Rango_Fila , Tipo_Rango_Colu] of Tipo_Elemento;


  oTipo_Objeto_Jugador = Class
    Private
      Coord: Tipo_Coord;
    Public
      Function Arriba (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): boolean;
      Function Abajo (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): boolean;
      Function Derecha (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): boolean;
      Function Izquierda (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): boolean;
      Function Arriba_Derecha (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): boolean;
      Function Arriba_Izquierda (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): boolean;
      Function Abajo_Derecha (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): boolean;
      Function Abajo_Izquierda (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): boolean;
      Function Coordenadas: Tipo_Coord;
  end;

  oTipo_Pacman = Class (oTipo_Objeto_Jugador)
    Private
      Puntos: word;
      Vidas: word;
      Capturado: word;
    Public
      Function Cant_Puntos: word;
      Function Cant_Vidas: word;
      Function Cant_Capturado: word;
      Procedure Ganar_Puntos;
      Procedure Pierde_Vida;
      Function Simbolo_Pacman: Tipo_Elemento;
  end;

  oTipo_Fantasma = Class (oTipo_Objeto_Jugador)
    Public
      Function Simbolo_Fantasma: Tipo_Elemento;
  end;

  oTipo_Objeto_Elemento = Class
    Private
      Cantidad: word;
    Public
  end;

  oTipo_Manzana = Class (oTipo_Objeto_Elemento)
    Private
      Valor: word;
    Public
      Function Manzanas: Word;
      Procedure Restar_Manzana;
      Function Simbolo_Manzana: Tipo_Elemento;
  end;

  oTipo_Bomba = Class (oTipo_Objeto_Elemento)
    Public
      Function Bombas: Word;
      Procedure Actualizar_Bombas (Cant: word);
      Function Simbolo_Bomba: Tipo_Elemento;
  end;

  oTipo_Piedra = Class (oTipo_Objeto_Elemento)
    Public
      Function Piedras: Word;
      Function Simbolo_Piedra: Tipo_Elemento;
  end;

  oTipo_Vacio = Class (oTipo_Objeto_Elemento)
    Public
      Function Simbolo_Vacio: Tipo_Elemento;
  end;

  oTipo_Juego_Pacman = Class
      Pacman: oTipo_Pacman;
      Fantasma: oTipo_Fantasma;
      Manzana: oTipo_Manzana;
      Bomba: oTipo_Bomba;
      Piedra: oTipo_Piedra;
      Vacio: oTipo_Vacio;
    Private
      Matriz: Tipo_Matriz;
      Minimo, Maximo: Tipo_Coord;
      HoraComienzo, HoraFin: string;
      Modo: Char;
    Public
      Procedure Crear;
      Function Estado_Casillero (Coord: Tipo_Coord): Tipo_Elemento;
      Procedure Ocupar_Casilla (Coord: Tipo_Coord; Elemento: Tipo_Elemento);
      Function Primero: Tipo_Coord;
      Function Ultimo: Tipo_Coord;
      Function Proximo (Coord: Tipo_Coord): Tipo_Coord;
      Function Hora_Comienzo: String;
      Function Hora_Fin: String;
      Procedure Actualizo_Capturado;
      Procedure Intercambio_Elementos (Coord_Actual: Tipo_Coord; Coord_Nueva: Tipo_Coord; Elemento: Tipo_Elemento);
  end;


implementation

//----------M�todos del Juego----------

Procedure oTipo_juego_Pacman.Crear;
var
  i: Tipo_Rango_Fila;
  j: Tipo_Rango_Colu;
  w_Contador: word;
  b_Ok: boolean;
begin
  self.Minimo.Fila:= Cte_Ini;
  self.Minimo.Colu:= Cte_Ini;
  self.Maximo.Fila:= Cte_Max_Fila;
  self.Maximo.Colu:= Cte_Max_Colu;
  
  for i:= self.Minimo.Fila to self.Maximo.Fila do
    for j:= self.Minimo.Colu to self.Maximo.Colu do
      self.Matriz[i, j]:= Cte_Vacio;

  //Creo al Pacman
  self.Pacman.Coord.Fila:= self.Maximo.Fila div 2;
  self.Pacman.Coord.Colu:= self.Maximo.Colu div 2;
  self.Matriz[self.Pacman.Coord.Fila,self.Pacman.Coord.Colu]:= Cte_Pacman;
  self.Pacman.Puntos:= Cte_Cant_Puntos;
  self.Pacman.Vidas:= Cte_Cant_Vidas;
  self.Pacman.Capturado:= Cte_Cant_Capturado;

  //Creo al fantasma
  randomize;
  b_Ok:= False;
  repeat
    i:= Random(self.Maximo.Fila - 1) + 1;
    j:= Random(self.Maximo.Colu - 1) + 1;
    if ((i <= self.Pacman.Coord.Fila - self.Maximo.Fila div 4) or (i >= self.Pacman.Coord.Fila + self.Maximo.Fila div 4))
        and ((j<= self.Pacman.Coord.Colu - self.Maximo.Colu div 4) or (j >= self.Pacman.Coord.Colu + self.Maximo.Colu div 4)) then
      begin
        b_Ok:= True;
        self.Fantasma.Coord.Fila:= i;
        self.Fantasma.Coord.Colu:= j;
        self.Matriz[self.Fantasma.Coord.Fila, self.Fantasma.Coord.Colu]:= Cte_Fantasma;
      end;
   until b_Ok;

   //Creo Manzanas
  self.Manzana.Cantidad:= Cte_Cant_Manzanas;
  self.Manzana.Valor:= Cte_Valor_Manzana;
  w_Contador:= 0;
  repeat
    i:= random(self.Maximo.Fila - 1) + 1;
    j:= random(self.Maximo.Colu - 1) + 1;
    if self.Matriz[i, j] = Cte_Vacio then
      begin
        self.Matriz[i, j]:= Cte_Manzana;
        w_Contador:= succ(w_Contador);
      end;
  until w_Contador = self.Manzana.Cantidad;

  //Creo Piedras
  self.Piedra.Cantidad:= Cte_Cant_Piedras;
  w_Contador:= 0;
  repeat
    i:= random(self.Maximo.Fila - 1) + 1;
    j:= random(self.Maximo.Colu - 1) + 1;
    if self.Matriz[i, j] = Cte_Vacio then
      begin
        self.Matriz[i, j]:= Cte_Piedra;
        w_Contador:= succ(w_Contador);
      end;
  until w_Contador = self.Piedra.Cantidad;

  //Creo Bombas
  self.Bomba.Cantidad:= Cte_Cant_Bombas;
  w_Contador:= 0;
  repeat
    i:= random(self.Maximo.Fila) + 1;
    j:= random(self.Maximo.Colu) + 1;
    if self.Matriz[i, j] = Cte_Vacio then
      begin
        self.Matriz[i, j]:= Cte_Bomba;
        w_Contador:= succ(w_Contador);
      end;
  until w_Contador = self.Bomba.Cantidad;
end;

Function oTipo_juego_Pacman.Estado_Casillero;
begin
  Result:= self.Matriz[Coord.Fila, Coord.Colu];
end;

Procedure oTipo_Juego_Pacman.Ocupar_Casilla;
begin
  self.Matriz[Coord.Fila, Coord.Colu]:= Elemento;
end;

Function oTipo_juego_Pacman.Primero;
begin
  Result:= self.Minimo;
end;

Function oTipo_juego_Pacman.Ultimo;
begin
  Result:= self.Maximo;
end;

Function oTipo_juego_Pacman.Proximo;
begin
  if Coord.Colu < self.Maximo.Colu then
    Coord.Colu:= succ(Coord.Colu)
  else
    begin
      Coord.Fila:= succ(Coord.Fila);
      Coord.Colu:= self.Minimo.Colu;
    end;
  Result:= Coord;
end;

Function oTipo_Juego_Pacman.Hora_Comienzo: String;
begin
  self.HoraComienzo:= 'Hora de comienzo: ' + FormatDateTime ('hh:mm',now);
  Result:= self.HoraComienzo;
end;

Function oTipo_Juego_Pacman.Hora_Fin: String;
begin
  self.HoraFin:= 'Hora de finalizacion: ' + FormatDateTime ('hh:mm',now);
  Result:= self.HoraFin;
end;

Procedure oTipo_Juego_Pacman.Actualizo_Capturado;
var
  b_ok: boolean;
  i: Tipo_Rango_Fila;
  j: Tipo_Rango_Colu;
begin
  self.Matriz[self.Pacman.Coord.Fila, self.Pacman.Coord.Colu]:= Cte_Vacio;
  self.Matriz[self.Fantasma.Coord.Fila, self.Fantasma.Coord.Colu]:= Cte_Vacio;

  //Devuelvo al pacman al centro
  self.Pacman.Coord.Fila:= self.Maximo.Fila div 2;
  self.Pacman.Coord.Colu:= self.Maximo.Colu div 2;
  self.Matriz[self.Pacman.Coord.Fila,self.Pacman.Coord.Colu]:= Cte_Pacman;

  //Vuelvo a colocar al fantasma aleatoreamente
  randomize;
  b_Ok:= False;
  repeat
    i:= Random(self.Maximo.Fila - 1) + 1;
    j:= Random(self.Maximo.Colu - 1) + 1;
    if ((i <= self.Pacman.Coord.Fila - self.Maximo.Fila div 4) or (i >= self.Pacman.Coord.Fila + self.Maximo.Fila div 4))
        and ((j<= self.Pacman.Coord.Colu - self.Maximo.Colu div 4) or (j >= self.Pacman.Coord.Colu + self.Maximo.Colu div 4))
        and (self.Matriz[i,j] = Cte_Vacio) then
      begin
        b_Ok:= True;
        self.Fantasma.Coord.Fila:= i;
        self.Fantasma.Coord.Colu:= j;
        self.Matriz[self.Fantasma.Coord.Fila, self.Fantasma.Coord.Colu]:= Cte_Fantasma;
      end;
   until b_Ok;
end;

Procedure oTipo_Juego_Pacman.Intercambio_Elementos(Coord_Actual: Tipo_Coord; Coord_Nueva: Tipo_Coord; Elemento: Tipo_Elemento);
begin
  self.Matriz[Coord_Actual.Fila, Coord_Actual.Colu]:= Cte_Vacio;
  self.Matriz[Coord_Nueva.Fila, Coord_Nueva.Colu]:= Elemento;
end;


//----------M�todos del Jugador (clase madre)----------

Function oTipo_Objeto_Jugador.Arriba (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): Boolean;
begin
  Coord_Actual:= self.Coord;

  Coord_Nueva.Fila:= pred(Coord_Actual.Fila);
  Coord_Nueva.Colu:= Coord_Actual.Colu;

  if (Coord_Nueva.Fila >= Cte_Ini) then
    begin
        Result:= True;
        self.Coord:= Coord_Nueva;
    end
  else  Result:= False;
end;

Function oTipo_Objeto_Jugador.Abajo (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): Boolean;
begin
  Coord_Actual:= self.Coord;

  Coord_Nueva.Fila:= succ(Coord_Actual.Fila);
  Coord_Nueva.Colu:= Coord_Actual.Colu;

  if (Coord_Nueva.Fila <= Cte_Max_Fila) then
    begin
        Result:= True;
        self.Coord:= Coord_Nueva;
    end
  else  Result:= False;
end;

Function oTipo_Objeto_Jugador.Derecha (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): Boolean;
begin
  Coord_Actual:= self.Coord;

  Coord_Nueva.Fila:= Coord_Actual.Fila;
  Coord_Nueva.Colu:= succ(Coord_Actual.Colu);

  if (Coord_Nueva.Colu <= Cte_Max_Colu) then
    begin
        Result:= True;
        self.Coord:= Coord_Nueva;
    end
  else  Result:= False;
end;

Function oTipo_Objeto_Jugador.Izquierda (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): Boolean;
begin
  Coord_Actual:= self.Coord;

  Coord_Nueva.Fila:= Coord_Actual.Fila;
  Coord_Nueva.Colu:= pred(Coord_Actual.Colu);

  if (Coord_Nueva.Colu >= Cte_Ini) then
    begin
        Result:= True;
        self.Coord:= Coord_Nueva;
    end
  else  Result:= False;
end;

Function oTipo_Objeto_Jugador.Arriba_Derecha (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): Boolean;
begin
  Coord_Actual:= self.Coord;

  Coord_Nueva.Fila:= pred(Coord_Actual.Fila);
  Coord_Nueva.Colu:= succ(Coord_Actual.Colu);

  if (Coord_Nueva.Fila >= Cte_Ini) and (Coord_Nueva.Colu <= Cte_Max_Colu) then
    begin
        Result:= True;
        self.Coord:= Coord_Nueva;
    end
  else  Result:= False;
end;

Function oTipo_Objeto_Jugador.Arriba_Izquierda (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): Boolean;
begin
  Coord_Actual:= self.Coord;

  Coord_Nueva.Fila:= pred(Coord_Actual.Fila);
  Coord_Nueva.Colu:= pred(Coord_Actual.Colu);

  if (Coord_Nueva.Fila >= Cte_Ini) and (Coord_Nueva.Colu >= Cte_Ini) then
    begin
        Result:= True;
        self.Coord:= Coord_Nueva;
    end
  else  Result:= False;
end;

Function oTipo_Objeto_Jugador.Abajo_Derecha (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): Boolean;
begin
  Coord_Actual:= self.Coord;

  Coord_Nueva.Fila:= succ(Coord_Actual.Fila);
  Coord_Nueva.Colu:= succ(Coord_Actual.Colu);

  if (Coord_Nueva.Fila <= Cte_Max_Fila) and (Coord_Nueva.Colu <= Cte_Max_Colu) then
    begin
        Result:= True;
        self.Coord:= Coord_Nueva;
    end
  else  Result:= False;
end;

Function oTipo_Objeto_Jugador.Abajo_Izquierda (var Coord_Actual: Tipo_Coord; var Coord_Nueva: Tipo_Coord): Boolean;
begin
  Coord_Actual:= self.Coord;

  Coord_Nueva.Fila:= succ(Coord_Actual.Fila);
  Coord_Nueva.Colu:= pred(Coord_Actual.Colu);

  if (Coord_Nueva.Fila <= Cte_Max_Fila) and (Coord_Nueva.Colu >= Cte_Ini) then
    begin
        Result:= True;
        self.Coord:= Coord_Nueva;
    end
  else  Result:= False;
end;

Function oTipo_Objeto_Jugador.Coordenadas;
begin
  Result:= self.Coord;
end;

//----------M�todos del Pacman----------

Function oTipo_Pacman.Cant_Puntos: word;
begin
  Result:= self.Puntos;
end;

Function oTipo_Pacman.Cant_Vidas: word;
begin
  Result:= self.Vidas;
end;

Function oTipo_Pacman.Cant_Capturado: word;
begin
  Result:= self.Capturado;
end;

Procedure oTipo_Pacman.Ganar_Puntos;
begin
  self.Puntos:= self.Puntos + Cte_Valor_Manzana;
end;

Procedure oTipo_Pacman.Pierde_Vida;
begin
  self.Vidas:= pred(self.Vidas);
  self.Capturado:= succ(self.Capturado);
  self.Puntos:= Cte_Cant_Puntos; //Vuelvo puntaje a 0
end;

Function oTipo_Pacman.Simbolo_Pacman: Tipo_Elemento;
begin
  Result:= Cte_Pacman;
end;

//----------M�todos del Fantasma----------

Function oTipo_Fantasma.Simbolo_Fantasma: Tipo_Elemento;
begin
  Result:= Cte_Fantasma;
end;

//----------M�todos de la Manzana----------

Function oTipo_Manzana.Manzanas: Word;
begin
  Result:= self.Cantidad;
end;

Procedure oTipo_Manzana.Restar_Manzana;
begin
  self.Cantidad:= pred(self.Cantidad);
end;

Function oTipo_Manzana.Simbolo_Manzana: Tipo_Elemento;
begin
  Result:= Cte_Manzana;
end;

//----------M�todos de la Bomba----------

Function oTipo_Bomba.Bombas: Word;
begin
  Result:= self.Cantidad;
end;

Procedure oTipo_Bomba.Actualizar_Bombas (Cant: word);
begin
  self.Cantidad:= cant;
end;

Function oTipo_Bomba.Simbolo_Bomba: Tipo_Elemento;
begin
  Result:= Cte_Bomba;
end;


//----------M�todos de la Piedra----------

Function oTipo_Piedra.Piedras: Word;
begin
  Result:= self.Cantidad;
end;

Function oTipo_Piedra.Simbolo_Piedra: Tipo_Elemento;
begin
  Result:= Cte_Piedra;
end;

//----------M�todos del Vac�o----------

Function oTipo_Vacio.Simbolo_Vacio: Tipo_Elemento;
begin
  Result:= Cte_Vacio;
end;



end.


