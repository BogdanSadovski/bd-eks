use запросы;

- о спортивном инвентаре (id_инвентаря, наименование, количество на складе, стоимость
одного часа проката, категория, залоговая стоимость);
- о заказе (№_заказа, дата заказа, id_инвентаря, количество, номер паспорта клиента,
количество часов проката, размер залога, скидка ).

create table inventory (
inventory_id int primary key,
name varchar(100),
per_count int,
price_per_hour int,
categort varchar(100),
kred_price int
);

create table order_info (
order_id int PRIMARY KEY,
order_date DATE,
inventory_id int,
foreign key (inventory_id) references inventory(inventory_id),
count int,
card_number varchar(100),
count_hours int,
pledge int,
sale int
);

Заполнить таблицы не менее чем тремя записями, такими, чтобы
результаты выполнения запросов были не пустыми.

INSERT INTO inventory (inventory_id, name, per_count, price_per_hour, categort, kred_price) VALUES
(1, 'Велосипед горный', 5, 150, 'Спорт', 3000),
(2, 'Роликовые коньки', 8, 100, 'Спорт', 2000),
(3, 'Палатка 4-местная', 3, 200, 'Туризм', 8000),
(4, 'Мангал большой', 4, 50, 'Пикник', 1500),
(5, 'Надувная лодка', 2, 300, 'Рыбалка', 12000),
(6, 'Проектор HD', 3, 250, 'Техника', 25000),
(7, 'Колонка JBL', 6, 100, 'Техника', 8000),
(8, 'Кофеварка', 4, 80, 'Бытовая техника', 5000),
(9, 'Набор для бадминтона', 10, 50, 'Спорт', 1200),
(10, 'Гироскутер', 2, 200, 'Электротранспорт', 15000);

INSERT INTO order_info (order_id, order_date, inventory_id, count, card_number, count_hours, pledge, sale) VALUES
(1, '2025-01-15', 1, 1, '1234-5678-9012-3456', 3, 3000, 0),
(2, '2025-01-16', 3, 1, '2345-6789-0123-4567', 24, 8000, 10),
(3, '2025-01-16', 7, 2, '3456-7890-1234-5678', 5, 16000, 5),
(4, '2025-01-17', 2, 1, '4567-8901-2345-6789', 2, 2000, 0),
(5, '2025-01-17', 5, 1, '5678-9012-3456-7890', 8, 12000, 15),
(6, '2025-01-18', 6, 1, '6789-0123-4567-8901', 4, 25000, 0),
(7, '2025-01-18', 1, 2, '7890-1234-5678-9012', 6, 6000, 10),
(8, '2025-01-19', 4, 1, '8901-2345-6789-0123', 4, 1500, 0),
(9, '2025-01-19', 9, 3, '9012-3456-7890-1234', 2, 3600, 20),
(10, '2025-01-20', 10, 1, '0123-4567-8901-2345', 1, 15000, 0),
(11, '2025-01-20', 8, 1, '1122-3344-5566-7788', 12, 5000, 10),
(12, '2025-01-21', 3, 1, '2233-4455-6677-8899', 48, 8000, 0),
(13, '2025-01-21', 2, 2, '3344-5566-7788-9900', 3, 4000, 5),
(14, '2025-01-22', 7, 1, '4455-6677-8899-0011', 8, 8000, 15),
(15, '2025-01-22', 1, 1, '5566-7788-9900-1122', 2, 3000, 0);


1. Выведите все наименования инвентаря и его категории, а также номера заказов и количество в них.
Выводить только те позиции инвентаря, у которых стоимость проката в час равна минимальной стоимости проката среди всего инвентаря.

select i.name, i.categort, o.order_id, o.count 
from inventory i
join order_info o on i.inventory_id = o.inventory_id
where i.price_per_hour = min(i.price_per_hour);

2. Для каждой категории инвентаря подсчитайте, сколько было заказов на инвентарь с залоговой стоимостью более 5000.

select i.categort, COUNT(o.order_id) 
from inventory i
join order_info o on i.inventory_id = o.inventory_id
where pledge < 5000;

3. Для каждого инвентаря из категории 'Спорт' выведите его ID, наименование и среднее количество часов проката.
Даже если на инвентарь не было заказов, он должен быть в результатах со значением 0.

select i.inventory_id, i.name, avg(o.count_hours)
from inventory i
join order_info o on i.inventory_id = o.inventory_id
where categort = 'Спорт';


Номера карт клиентов, даты заказов и наименование инвентаря, который они брали в прокат.
Затем выберите из представления информацию о заказах за текущий месяц.


CREATE view aaa as
select o.card_number, o.order_date, i.name 
from order_info o, inventory i
where i.inventory_id = o.inventoty_id
group by i.name;

select i.name from aaa
where o.date = INTERVAL CURDATE() - 1 MONTH();

CREATE VIEW aaa AS
SELECT 
    o.card_number,
    o.order_date,
    i.name AS наименование_инвентаря
FROM order_info o
JOIN inventory i ON i.inventory_id = o.inventory_id;

SELECT card_number, order_date, наименование_инвентаря 
FROM aaa
WHERE YEAR(order_date) = YEAR(CURDATE()) 
  AND MONTH(order_date) = MONTH(CURDATE());



2. Создайте представление:
Наименование, категорию и количество на складе инвентаря, имеющегося в прокате в максимальном количестве.
Затем выберите из представления информацию об инвентаре категории «Спорт».

create view bbb as
select i.name, i.categort, o.count 
from inventory i
join order_info o on i.inventory_id = o.inventory_id
where o.count = max(o.count);

select i.name from bbb
where i.categort = 'Спорт'

Процедуры:
1. Написать хранимую процедуру вычисляющую общее количество взятого в прокат инвентаря. 
ID инвентаря передается в процедуру в качестве параметра.

delimiter //
create procedure qqq(in inv_id int)
begin
	select i.inventory_id, count(o.order_id) 
	from inventory i
	left join order_info o on i.inventory_id = o.inventory_id
	where i.inventory_id = inv_id;
	group by i.inventory_id
end
delimiter ;

call qqq(3)

2. Написать процедуру, подсчитывающую общую стоимость инвентаря каждой категории на складе, если сегодня не было заказов.
Если заказы были, вывести сообщение.

delimiter //
create procedure www()
begin
	declare заказ int;
	select count(*) into заказ
	from order_info
	where date(order_date) = curdate()

	if заказ > 0 then
	select "nonono";
	else 
	select i.category, sum(i.price_per_hour * o.count_hours)
	from inventory i
	left join order_info o on i.inventory_id = o.inventory_id
	group by i.category:
	end if;
end
delimiter ;

Триггеры:
3. Написать триггер, который проверяет при добавлении заказа, что количество взятое в прокат не превышает количество доступное на складе.

DELIMITER //
CREATE TRIGGER проверка_запасов
BEFORE INSERT ON order_info
FOR EACH ROW
BEGIN
    DECLARE доступно INT;
    
    -- Получаем текущее количество на складе
    SELECT per_count INTO доступно 
    FROM inventory 
    WHERE inventory_id = NEW.inventory_id;
    
    -- Проверяем, достаточно ли инвентаря
    IF NEW.count > доступно THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Недостаточно инвентаря на складе!';
    END IF;
END //
DELIMITER ;

4. Написать триггер, который автоматически пересчитывает общую выручку по категориям при каждом новом заказе.


CREATE database if not exists shop;
use shop;

create table tovar(
tovar_id int primary key,
name varchar(100),
category varchar(100),
price int,
count int
);

create table prodazhi(
prod_num int PRIMARY key,
tovar_id int,
tovar_count int,
sale_date date,
foreign key (tovar_id) references tovar(tovar_id)
);

insert into tovar values
(1,'мяч','спорт',100,12),
(2,'телевизор','техника',600,13),
(3,'диван','мебель',400,2);

insert into tovar values
(4,'стул','мебель',200,14);

insert into prodazhi values
(1,1,2,'2025-01-21'),
(2,2,3,'2025-01-22'),
(3,3,1,'2025-01-23');

insert into prodazhi values
(4,3,3,'2025-01-21');


select category, GROUP_CONCAT(name) 
from tovar
group by category;

-- Триггер (Automation): Написать триггер для таблицы «Рейсы», 
-- который при регистрации нового полета автоматически укажет текущую дату 
-- в поле дата_вылета, если диспетчер забыл её указать.


delimiter





select category, name 
from tovar
group by category, name;

SELECT category, GROUP_CONCAT(name)
FROM tovar
GROUP BY category;

select sale_date, sum(tovar_count)
from prodazhi 
group by sale_date; 

select t.* from tovar t
left join prodazhi p on t.tovar_id = p.tovar_id 
where p.tovar_id is null;


DELIMITER //

CREATE PROCEDURE mydb.ShowAll(in tovar_ids int)
BEGIN
    SELECT tovar_id, sum(tovar_count) 
	FROM prodazhi
	where tovar_id = tovar_ids
	group by tovar_id;
END //

DELIMITER ; 

CALL showCount(2);
CALL aaa();

-- Создаем и сразу используем
CREATE VIEW продажи1 AS
SELECT t.name, MAX(p.tovar_count) as max_count
FROM prodazhi p, tovar t 
WHERE p.tovar_id = t.tovar_id
GROUP BY t.tovar_id;

-- Смотрим результат
SELECT name, max_count 
FROM продажи1 
WHERE max_count < 3;

-- 2. Выведите список категорий и количество товаров в каждой категории
select t.category, sum(t.count)
from tovar t
group by t.category;

-- 3. Выведите сумму продаж (количество * цена) для каждой даты

select p.sale_date, sum(t.price * p.tovar_count) from prodazhi p
join tovar t on t.tovar_id = p.tovar_id
GROUP by p.sale_date; 

-- 4. Выведите информацию о товарах, которые никогда не продавались
select t.tovar_id, t.name from tovar t
left join prodazhi p on p.tovar_id = t.tovar_id 
where p.tovar_id is null

5. Напишите хранимую процедуру GetTotalSales, которая вычисляет
общую выручку от продаж товара. ID товара передается в процедуре
в качестве параметра

delimiter //
begin
	CREATE procedure GetTotalSales(in tovar_id_param int)
	SELECT t.tovar_id, sum(t.price*p.tovar_count)
	from tovar t
	where t.tovar_id = tovar_id_param
	join prodazhi p on t.tovar_id = p.tovar_id
	group by t.tovar_id
end
delimiter ;

call GetTotalSales(2)

6. Напишите процедуру CategoryReport, которая подсчитывает среднюю цену товаров 
в каждой категории, если сегодня не было продаж. Если продажи были, 
вывести сообщение "Сегодня были продажи"

delimiter //
create procedure CategoryReport()
begin
	declare продажи_сегодня int;
	select count(*) into продажи_сегодня
	from prodazhi
	where sale_date = CURDATE()
	
	if продажи_сегодня > 0 then
	select 'иммо' as сообщение;
	else
	select category, avg(price)
	from tovar 
	group by category;
	end if;
end
delimiter ;

7. Создайте представление ProductSalesSummary, содержащее информацию:
Название товара

Минимальное количество проданного товара в одной продаже

Максимальное количество проданного товара в одной продаже

Среднее количество проданного товара в одной продаже

CREATE view ProductSalesSummaryy as
select t.name, min(p.tovar_count) as minim, max(p.tovar_count), avg(p.tovar_count)
from tovar t, prodazhi p 
where t.tovar_id = p.tovar_id
group by t.name;

8. Выберите из представления ProductSalesSummary информацию о товарах,
где минимальное количество в одной продаже больше 2

select name, minim from ProductSalesSummaryy
where minim > 2;


create database if not exists ships;

use  ships;


-- О кораблях (id_корабля, название [например: "Миллениум", "Восток-1"], класс [Грузовой/Пассажирский], год_постройки);
-- О капитанах (id_капитана, ФИО, раса [Человек, Марсианин, Андроид], лицензия);
-- О рейсах (id_рейса, id_корабля, id_капитана, пункт_назначения, дата_вылета, стоимость_топлива).

create table ship (
	ship_id int auto_increment primary key,
	name varchar(100) not null,
	class varchar(100)not null,
	start_date date not null
);

create table captain(
	captain_id int auto_increment primary key,
	fio varchar(100) not null,
	rase varchar(100) not null,
	license varchar(100) not null
);

create table flight (
	flight_id int auto_increment primary key,
	ship_id int not null,
	foreign key (ship_id) references ship(ship_id) on delete cascade,
	captain_id int not null,
	foreign key (captain_id) references captain(captain_id) on delete cascade,
	place varchar(100) not null,
	departure_date date not null,
	fill_price int not null
);

INSERT INTO ship VALUES
(1, 'Миллениум', 'Грузовой', '2010-05-15'),
(2, 'Восток-1', 'Пассажирский', '2015-08-20'),
(3, 'Черная жемчужина', 'Грузовой', '2008-12-10'),
(4, 'Серенити', 'Пассажирский', '2018-03-25'),
(5, 'Нормандия', 'Грузовой', '2020-11-30'),
(6, 'Ностромо', 'Грузовой', '2012-07-08'),
(7, 'Энтерпрайз', 'Пассажирский', '2019-09-14'),
(8, 'Галактика', 'Пассажирский', '2017-04-18'),
(9, 'Пилигрим', 'Грузовой', '2013-10-22'),
(10, 'Прометей', 'Грузовой', '2022-01-05');

INSERT INTO captain VALUES
(1, 'Иванов Иван Иванович', 'Человек', 'LIC-CPT-001'),
(2, 'Смит Джон', 'Человек', 'LIC-CPT-002'),
(3, 'АР-Д2', 'Андроид', 'LIC-CPT-003'),
(4, 'Кхан Нур', 'Марсианин', 'LIC-CPT-004'),
(5, 'Петров Петр Петрович', 'Человек', 'LIC-CPT-005'),
(6, 'Ждан Марта Вольфовна', 'Марсианин', 'LIC-CPT-006'),
(7, 'Т-800', 'Андроид', 'LIC-CPT-007'),
(8, 'Сидоров Алексей', 'Человек', 'LIC-CPT-008'),
(9, 'Зорг Клакс', 'Марсианин', 'LIC-CPT-009'),
(10, 'Данные', 'Андроид', 'LIC-CPT-010'),
(11, 'Ковалева Мария', 'Человек', 'LIC-CPT-011'),
(12, 'Р2-Д2', 'Андроид', 'LIC-CPT-012');

INSERT INTO flight VALUES
(1, 1, 1, 'Марс', '2025-03-15', 5000),
(2, 1, 3, 'Юпитер', '2025-03-20', 8000),
(3, 2, 2, 'Венера', '2025-04-01', 3000),
(4, 2, 4, 'Сатурн', '2025-04-10', 12000),
(5, 3, 5, 'Меркурий', '2025-03-25', 2000),
(6, 3, 6, 'Плутон', '2025-04-05', 15000),
(7, 4, 7, 'Луна', '2025-03-18', 1000),
(8, 4, 8, 'Марс', '2025-04-12', 5500),
(9, 5, 9, 'Ио', '2025-03-28', 7000),
(10, 5, 10, 'Европа', '2025-04-15', 9000),
(11, 6, 1, 'Титан', '2025-04-03', 11000),
(12, 6, 2, 'Марс', '2025-04-20', 5200),
(13, 7, 3, 'Венера', '2025-03-22', 3200),
(14, 7, 4, 'Нептун', '2025-04-08', 18000),
(15, 8, 5, 'Уран', '2025-03-30', 16000),
(16, 8, 6, 'Церера', '2025-04-18', 4000),
(17, 9, 7, 'Марс', '2025-04-02', 5300),
(18, 9, 8, 'Ганимед', '2025-04-22', 13000),
(19, 10, 9, 'Каллисто', '2025-03-27', 14000),
(20, 10, 10, 'Марс', '2025-04-25', 5100),
(21, 1, 11, 'Фобос', '2025-04-28', 2500),
(22, 2, 12, 'Деймос', '2025-04-30', 2600),
(23, 3, 1, 'Венера', '2025-05-01', 3400),
(24, 4, 2, 'Юпитер', '2025-05-03', 8200),
(25, 5, 3, 'Сатурн', '2025-05-05', 12500);


-- Выборка (JOIN + WHERE): Написать SQL-запрос, который выводит ФИО капитана, название корабля и пункт назначения.
-- Условие: Выводить только те рейсы, где стоимость_топлива превышает 5000 галактических кредитов.

SELECT f.place, c.fio, s.name 
from flight f
join ship s on f.ship_id = s.ship_id
join captain c on f.captain_id = c.captain_id
where fill_price <= 5000;

-- Агрегация (AVG + GROUP BY): Написать SQL-запрос, который определяет среднюю стоимость
-- топлива для каждого класса кораблей (грузовой/военный/пассажирский). Условие: Учитывать
-- только корабли с годом_постройки после 2150 года.

select s.class, avg(f.fill_price)
from ship s
left join flight f on f.ship_id = s.ship_id
where year(s.start_date) > 2150
GROUP by s.class; 


-- Триггер (Automation): Написать триггер для таблицы «Рейсы», 
-- который при регистрации нового полета автоматически укажет текущую дату 
-- в поле дата_вылета, если диспетчер забыл её указать.


delimiter //
 CREATE trigger aaa
 before insert on flight
 for each row
 begin
	if  departure_date is null then
 	set new.departure_date = curdate();
end if
 end
 
delimiter ;


1. Триггер для капитанов:
Написать триггер, который при добавлении нового капитана автоматически проверяет, что его возраст (рассчитанный из даты рождения) не меньше 25 лет. Если возраст меньше 25 или дата рождения не указана, генерировать ошибку.

delimiter //
	create trigger aaa
	before insert on captain
	for each row
	begin
		if timestampdiff(year, New.cap_date, curdate()) => 25 then
		set new.cap_date = cap_date;
		else
		set message_text as "ошибка"
		end if;
	end
delimiter ;



UPDATE ship SET class = 'Грузовой' WHERE ship_id = 1;
DELETE FROM captain WHERE captain_id = 1;


-- Представление (VIEW) + Subquery: Создать представление, содержащее 
-- Название корабля, Расу капитана и Стоимость топлива. В представление должны попасть
-- только рейсы стоимостью выше 1000.

create view abc as
select s.name, c.rase, f.fill_price
from ship s
join flight f on f.ship_id = s.ship_id
join captain c on f.captain_id = c.captain_id
where f.fill_price > 1000;

-- Написать SQL-запрос к созданному представлению, который выводит расу, 
-- представители которой совершили рейсы с максимальной суммарной стоимостью 
-- (то есть, какая раса тратит больше всех денег).

select rase from abc
where fill_price = (select max(fill_price) from flight);


-- Хранимая процедура (Logic): Написать хранимую процедуру, которая принимает 
-- id_рейса и расстояние в световых годах (входной параметр). 
-- Процедура высчитывает итоговый налог на перелет. Л
-- огика: Если расстояние составляет более 10 световых лет, предоставить субсидию (скидку) 10%. 
-- Если меньше — полная стоимость. Записать итоговую сумму в выходной параметр.

delimiter //
create procedure Logic ()
delimiter ;


DELIMITER $$

CREATE PROCEDURE get_square(
    IN p_number INT,
    OUT p_result INT
)
BEGIN
    SET p_result = p_number * p_number;
END$$

DELIMITER ;

CALL get_square(5, @res);
SELECT @res AS result;








