create database tienda_tecno
	with encoding = 'UTF8'
	template= template0;
*/ crear tablas*/

create table clientes(
idCliente serial primary key,
nombreCliente varchar(50) not null,
correoCliente varchar(120) not null unique,
fechaRegistro date not null default current_date
);

create table productos(
idProducto serial primary key,
nombreProducto varchar (50) not null,
precioProducto numeric (10, 2) not null check (precioproducto  > 0),
stock integer not null default 0
);

create table pedido(
idPedido serial primary key,
idClienteFK integer not null references clientes(idCliente) on delete cascade,
fechaPedido timestamp not null default now(),
estadoPedido varchar(20) not null default 'Pendiente'
);

create table DetallePedido(
idPedidoFK integer not null references pedido(idPedido) on delete cascade,
idProductoFK integer not null references productos(idProducto) on delete cascade,
cantidad integer not null check (cantidad >0),
primary key (idPedidoFK, idProductoFK)
);

alter table clientes
add telefono varchar (20);

alter table productos alter column nombreProducto type varchar(150);

alter table pedido rename column estadoPedido to estado;

alter table productos
add constraint productos check (stock >= 0);



