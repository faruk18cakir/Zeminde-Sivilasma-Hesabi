function Sivilasma_Hesabi

sondajbas = input('Lütfen sondajın başlangıcını giriniz: ');
sondajson = input('\nLütfen sondajın bitimini giriniz: ');
ara = input('\nLütfen sondaj aralığını giriniz: ');

fprintf('\n');

dongusay = (sondajson - sondajbas) / ara;
a = round(dongusay);

if (dongusay - a) < 0.5
    x = a + 1;
else
    x = a;
end
Pa = 100;
Ce= 0.73/0.6;
mat=zeros(x,18);
for ii = 1:dongusay+1 %derinlik için
    mat(ii,1) = sondajbas;
    sondajbas = sondajbas + ara;
end
fprintf('\nLütfen değerleri, derinlik değerleriyle aynı sırada giriniz.\n')
fprintf('\nLütfen Ham N değerlerini giriniz: \n')

for ii= 1:1:dongusay+1 %Ham N değerleri için
    N = input('N = ');
    mat(ii,2)=N;
end

fprintf('\nLütfen değerleri derinlik değerleriyle aynı sırada giriniz.\n');
fprintf('\nLütfen birim hacim ağırlık değerlerini giriniz.\n');

for ii= 1:1:dongusay+1 %birim hacim ağırlık için
    
gama=input('Birim hacim ağırlık = '); 
     mat(ii,6)=gama;
end

efektifgerilme = 0; %efektif gerilme için

for ii = 2:dongusay+1
    efektifgerilme = efektifgerilme + (ara / 2) * (mat(ii,6) - 9.81);
    mat(ii,7) = efektifgerilme;
end

for ii = 1:dongusay+1 %Cn değerleri için
    
     mat(ii,3)=((Pa/ mat(ii,7)) ^ 0.5);
end
for ii = 1:dongusay+1 %N60 değerleri için
    
     mat(ii,4)= mat(ii,2)*Ce*1*1*1;
end
for ii = 1:dongusay+1 %N160 değerleri için
    
    mat(ii,5)=mat(ii,3)*mat(ii,4);
end

gerilme = 0; %normal gerilme için
for ii = 2:dongusay+1
    
    gerilme = gerilme + (ara / 2) * (mat(ii,6));
    mat(ii,8) = gerilme;
end

for ii = 1:dongusay+1 %alfa değeri için
    
    mat(ii,9) = -1.012 - 1.126 * sin(pi/180*(((mat(ii,1) - mat(1,1))/ 11.73) + 5.133));
end

for ii = 1:dongusay+1 %beta değeri için
    
    mat(ii,10) = 0.106 + 0.118 * sin(pi / 180 * (((mat(ii,1) - mat(1,1)) / 11.28) + 5.142));
end

for ii = 1:dongusay+1 %rd değeri için
    
    mat(ii,11) = exp(mat(ii,9) + (mat(ii,10) * 7.5));
    %7.5 sayısı Zemin için M değeridir ( Kabul Edildi )
end

for ii = 1:dongusay+1 %C? değeri için
    
   mat(ii,12) = 1 / ( 18.9 - 2.55 * sqrt(mat(ii,5)));

        if mat(ii,12) > 0.3
            mat(ii,12) = 0.3;
        else 
            mat(ii,12) = mat(ii,12);
        end
end

for ii = 1:dongusay+1 %K? değeri için
    
    mat(ii,13) = 1 - mat(ii,12) * log(mat(ii,7) / Pa); 

    if mat(ii,13) > 1.10
        mat(ii,13) = 1.10;
    else
        mat(ii,13) = mat(ii,13);
    end
end
disp('Pga ve Fpga Değerini TBDY''ye göre giriniz')
Pga = input('\n Pga değerini giriniz: ');
Fpga = input('\n Fpga değerini giriniz: ');
aMax = Fpga * (Pga * 9.81);
for ii = 1:dongusay+1 %CSR değeri için
    
   mat(ii,14) = 0.65 * (mat(ii,8) / mat(ii,7)) * (aMax / 9.81) * mat(ii,11);
end

for ii = 1:dongusay+1 %CRR1 değeri için
    
    mat(ii,15) = exp((mat(ii,5) / 14.1) + (mat(ii,5) / 126) ^ 2 - (mat(ii,5) / 23.6) ^ 3 + (mat(ii,5) / 25.4) ^ 4 - 2.8);
end

M = 7.5;
Msf = 6.9 * exp((-M) / 4) - 0.058;
for ii = 1:dongusay+1 %CRR2 değeri için
    
    mat(ii,16) = mat(ii,15) * Msf * mat(ii,13);
end

for ii = 1:dongusay+1 %Fs değeri için
    
    mat(ii,17) = mat(ii,14) / mat(ii,16);
end

for ii = 1:dongusay+1 %sıvılaşmış mı? sıvılaşmamış mı?
    %Sonuç 1 ise Sıvılaşmış 0 ise sıvılaşmamıştır.
    
    if mat(ii,17) > 1 
        mat(ii,18) = 0;
    else
        mat(ii,18) = 1;
    end
end
fprintf('\nKullanıcı Girdisi Sonucu Ortaya Çıkan Tablo Bu Şekildedir\n');
fprintf('\n');
xlswrite('Sivilasma.xls',mat);