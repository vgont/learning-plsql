drop table Motoristas cascade constraints;
drop table CNHS cascade constraints;
drop table Veiculos cascade constraints;
drop table Ruas cascade constraints;
drop table Acidentes cascade constraints;
drop table Multas cascade constraints;

drop sequence seq_id_cnhs;
drop sequence seq_id_motoristas;
drop sequence seq_id_veiculo;
drop sequence seq_id_ruas;
drop sequence seq_id_acidentes;
drop sequence seq_id_multas;

create table Motoristas(
	id number not null,
	nome varchar(50) not null,
	cpf varchar(50) not null,
);

create table CNHS (
	id number primary key,
	id_motorista number primary key,
	nr_cnh varchar(50) not null,
	pontos number not null,
	status_cnh varchar(50) default 'ativa' null,
	tp_cnh varchar(50) not null,
	constraint fk_cnhs_motoristas foreign key (id_motorista) references Motoristas (id),
	constraint ck_pontos_cnh check (pontos <= 40),
	constraint ck_status_cnh check (status_cnh in ('ativa', 'suspensa')),
	constraint ck_tipo_cnh check (tp_cnh in ('normal', 'trabalho'))
);

create table Veiculos(
	id number not null,
	id_motorista number not null,
	placa varchar(50) not null,
	constraint fk_veiculos_motoristas foreign key (id_motorista) references Motoristas (id_motorista), 
);

create table Ruas(
	id number not null,
	cep varchar(50) not null,
	nome varchar(50) not null,
);

create table Acidentes(
	id number not null,
	id_motorista number not null,
	id_causador number null,
	id_veiculo number not null,
	id_rua number not null,
	dt_acidente date not null,
	descricao varchar(250) not null,
	constraint fk_acidentes_motoristas foreign key (id_motorista) references Motoristas (id_motorista), 
	constraint fk_acidentes_veiculos foreign key (id_veiculo) references Veiculos (id_veiculo), 
	constraint fk_acidentes_ruas foreign key (id_rua) references Ruas (id_rua),
);

create table Multas(
	id number not null,
	id_motorista number not null,
	id_veiculo number not null,
	descricao varchar(250) not null,
	valor number not null,
	dt_inicio date not null,
	dt_vencimento date not null,
	dt_pagamento date null,
	constraint fk_multas_motoristas foreign key (id_motorista) references Motoristas (id_motorista), 
	constraint fk_multas_veiculos foreign key (id_veiculo) references Veiculos (id_veiculo), 
);

create sequence sq_id_motoristas start with 1 increment by 1;
create sequence sq_id_cnhs start with 1 increment by 1;
create sequence sq_id_veiculos start with 1 increment by 1;
create sequence sq_id_ruas start with 1 increment by 1;
create sequence sq_id_acidentes start with 1 increment by 1;
create sequence sq_id_multas start with 1 increment by 1;

create or replace trigger tr_id_motoristas
before insert on motoristas
for each row
declare
	v_id motoristas.id%type;
begin
	select sq_id_motoristas.nextval into v_id from dual;
	:new.id := v_id; 
end;

create or replace trigger tr_id_cnhs
before insert on cnhs
for each row
declare
	v_id cnhs.id%type;
begin
	select sq_id_cnhs.nextval into v_id from dual;
	:new.id := v_id; 
end;

create or replace trigger tr_id_veiculos
before insert on veiculos
for each row
declare
	v_id veiculos.id%type;
begin
	select sq_id_veiculos.nextval into v_id from dual;
	:new.id := v_id; 
end;

create or replace trigger tr_id_ruas
before insert on ruas
for each row
declare
	v_id ruas.id%type;
begin
	select sq_id_ruas.nextval into v_id from dual;
	:new.id := v_id; 
end;

create or replace trigger tr_id_acidentes
before insert on acidentes
for each row
declare
	v_id acidentes.id%type;
begin
	select sq_id_acidentes.nextval into v_id from dual;
	:new.id := v_id; 
end;

create or replace trigger tr_id_multas
before insert on multas
for each row
declare
	v_id multas.id%type;
begin
	select sq_id_multas.nextval into v_id from dual;
	:new.id := v_id; 
end;
