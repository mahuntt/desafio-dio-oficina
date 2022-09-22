create database mechanics;
use mechanics;

create table clients(
	idClient int auto_increment primary key,
    Fname varchar(20),
    Minit char(3),
    Lname varchar(20),
	CPF char(11) not null,
    Contact varchar(20)
);

insert into clients (Fname, Minit, Lname, CPF, Contact)
	values 
		("Lucas", "V", "Cesar", 12345678924, "1178654398"),
		("Roberto", "D", "Atalaia", 12333378924, "1176879398"),
		("Felipe", "S", "Massa", 12398778924, "1176873902");

create table vehicle(
	idVehicle int auto_increment primary key,
    Model varchar(45),
    License_plate char(7) unique not null,
    Problem varchar(300),
	constraint fk_client_vehicle foreign key (idVehicle) references clients(idClient)
);

insert into vehicle (Model, License_plate, Problem)
	values 
		("Mercedes C180", "ABCD157", "Pastilha de freio gasta"),
		("Volvo XC40", "BFGH122", "Porta não está fechando"),
		("Toyota Corolla", "LKJP987", "Retrovisor quebrado");

create table mechanics(
	idMechanic int auto_increment primary key,
    mName varchar(50),
    Contact varchar(20),
    Speciality varchar(80)
);

insert into mechanics (mName, Contact, Speciality)
	values 
		("Adalto", "1176549876", "Parte Elétrica"),
		("Fernando", "1154327865", "Mecanico Sênior");

create table service_request(
	idRequest int auto_increment primary key,
    Date_sr date,
    srValue float,
    srStatus enum("Analisando", "Em progresso", "Aguardando", "Concluido"),
    fDate_sr date,
    srDescription varchar(300),
    idcostumer_sr int,
	idmechanic_sr int,
	constraint fk_sr_customer foreign key (idcostumer_sr) references clients(idClient)
);

insert into service_request (Date_sr, srValue, srStatus, fDate_sr, srDescription, idcostumer_sr, idmechanic_sr)
	values 
		("2022-03-22", 500, "Concluido", "2022-03-28", "Troca de pastilha de freio", "1", "1"),
		("2022-05-12", 3000, "Em progresso", "2022-03-28", "Troca de maçaneta", "2", "2"),
        ("2022-07-02", 450, "Em progresso", "2022-08-03", "Troca de retrovisor", "3", "3");
	
create table part(
	idPart int auto_increment primary key,
    pValue float,
    pmValue float,
    pDescription varchar(215)
);

insert into part (pValue, pmValue, pDescription)
	values 
		("450", "50", "Pastilha de freio"),
		("2000", "1000", "Maçaneta"),
        ("250", "150", "Retrovisor");
        
select * from clients;

select * from clients c, service_request s where c.idClient = s.idRequest;
	
select * from clients c, service_request s
	where c.idClient = idRequest
	group by idRequest;

select mName, Speciality from  mechanics;

select Fname, srDescription, mName from clients
	inner join service_request
	on idClient = idcostumer_sr
	join mechanics
	on idMechanic = idmechanic_sr;