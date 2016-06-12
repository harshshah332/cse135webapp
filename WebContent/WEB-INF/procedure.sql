CREATE OR REPLACE FUNCTION proc_insert_orders(queries INT, new INT) RETURNS void AS $$
DECLARE
   priceList FLOAT[];
   productList INTEGER[];
   idx INT;
   diff INT;
   rand INT;
   tables CURSOR FOR SELECT p.id, round(sum(o.price)) as sum FROM orders o, products p WHERE o.product_id = p.id group by p.id order by sum desc limit 50 + new;
BEGIN
   idx := 0;
   FOR table_record IN tables LOOP
      priceList[idx] := table_record.sum;
      productList[idx] := table_record.id;
      idx := idx + 1;
   END LOOP;

   for a in 1..new LOOP
      diff := priceList[50-a] - priceList[50-a+new] + 1;
      rand := random() * 100 + 1;
      INSERT INTO ORDERS(user_id, product_id, quantity, price, is_cart) VALUES(rand, productList[50-a+new], 1, diff, false);
      INSERT INTO log(user_id, product_id, quantity, price, is_cart, states) VALUES(rand, productList[50-a+new], 1, diff, false, (SELECT s.name FROM states s INNER JOIN users u ON s.id = u.state_id WHERE u.id = rand));
   END LOOP;
   for a in 0..queries-new-1 LOOP
      rand := random() * 100 + 1;
      INSERT INTO ORDERS(user_id, product_id, quantity, price, is_cart) VALUES(rand, productList[a % (50-new)], 1, 100, false);
      INSERT INTO log(user_id, product_id, quantity, price, is_cart, states) VALUES(rand, productList[a % (50-new)], 1, 100, false, (SELECT s.name FROM states s INNER JOIN users u ON s.id = u.state_id WHERE u.id = rand));
   END LOOP;
END;
$$ LANGUAGE plpgsql;
