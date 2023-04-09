# 概要
シフトを自動制作してくれるwebアプリ  
https://shift-creating-app.herokuapp.com


下記のemailとパスワードでログインして頂くと機能を見れます。

Email:
```
1@yahoo.co.jp
```

パスワード:
```
Aa1111
```

# 工夫した点
シフトを割り当てる方法を工夫しました。スタッフの勤務希望時間の割合で決めています。例えばスタッフが3人いて月に40、50、60時間の勤務希望時間だとすると、勤務時間が4：5：6に近づくように割り当てる。そうすることによってスタッフの勤務希望時間の合計と勤務時間の合計の差でどれくらいスタッフが足りていないかを見ることができます。

# 苦労した点
多対多のアソシエーションが一番苦労しました。１対多のアソシエーションはすぐに理解する事ができたのですが、多対多のアソシエーションに一番時間を費やしました。中間テーブルによってどっちが複数持てるのか、外部キーはどこが所有するのか等、非常に迷いました。解決策としてやりたいことを図や絵や言葉で表現しながら進めていくことで、無事に解決する事ができました。
