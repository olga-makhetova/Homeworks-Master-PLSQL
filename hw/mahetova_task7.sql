declare
  -- 1) Создайте тип record с тремя полями. Тип полей на ваш выбор.
  type t_record is record(v varchar2(100 char),
                          n number not null := 0,
                          d date := sysdate);
  -- 2) Создайте несколько переменных с этим типом в обычном анонимном блоке.
  v_rec1 t_record;
  v_rec2 t_record;
begin
  -- 3) Присвойте значения первому полю всех переменных из п.2.
  v_rec1.v := 'first';
  v_rec2.v := 'second';

  -- 4) Выведите значения полей в буфер вывода.
  dbms_output.put_line('v_rec1: ' || 'v = ' || v_rec1.v || ', n = ' || v_rec1.n || ', d = ' || to_char(v_rec1.d, 'dd.mm.yyyy hh24:mi:ss'));
  dbms_output.put_line('v_rec2: ' || 'v = ' || v_rec2.v || ', n = ' || v_rec2.n || ', d = ' || to_char(v_rec2.d, 'dd.mm.yyyy hh24:mi:ss'));

  /* 5) Присвойте одной из переменных значение null.
        Попробуйте сделать условие, если переменная равна null, то выводится сообщение “It’s null”.
        Если не null, то сообщение “It’s not null”. Можно использовать case из предыдущей лекции.
  */
/*  
  v_rec1 := null;
  if v_rec1 is null then -- ERROR
    dbms_output.put_line('It’s null');
  else
    dbms_output.put_line('It’s not null');
  end if;
*/
end;
/

/*
6) Создайте запись с использованием rowtype от таблицы payment_detail_field.
   Создайте переменную, через select получите в неё строку из таблицы, выведите несколько полей в буфер вывода.
*/
declare
  v_rec payment_detail_field%rowtype;
begin
  select * into v_rec
    from payment_detail_field
    where rownum = 1;

  dbms_output.put_line('v_rec: ');
  dbms_output.put_line('FIELD_ID = ' || v_rec.field_id || ', NAME = ' || v_rec.name || ', DESCRIPTION = ' || v_rec.description);
end;
/
