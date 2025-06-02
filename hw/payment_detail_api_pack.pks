/*
  Автор: Махетова Ольга
  Описание пакета: API для сущности “Детали платежа”
*/

create or replace package payment_detail_api_pack
as
  -- Данные платежа добавлены или обновлены
  procedure insert_or_update_payment_detail(p_payment_id   payment.payment_id%type,
                                            p_payment_data t_payment_detail_array);                                            

  -- Детали платежа удалены
  procedure delete_payment_detail(p_payment_id         payment.payment_id%type,
                                  p_payment_delete_ids t_number_array);                                  

  procedure is_changes_through_api;
end payment_detail_api_pack;
/
