/*
  �����: �������� �����
  �������� ������: API ��� �������� ������� ��������
*/

create or replace package payment_detail_api_pack
as
  -- ������ ������� ��������� ��� ���������
  procedure insert_or_update_payment_detail(p_payment_id   payment.payment_id%type,
                                            p_payment_data t_payment_detail_array);                                            

  -- ������ ������� �������
  procedure delete_payment_detail(p_payment_id         payment.payment_id%type,
                                  p_payment_delete_ids t_number_array);                                  
end payment_detail_api_pack;
/
