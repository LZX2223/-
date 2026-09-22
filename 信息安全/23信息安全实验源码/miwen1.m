ciphertext=['UZQSOVUOHXMOPVGPOZPEVSGZWSZOPFPESXUDBMETSXAIZVUEPHZHMDZSHZQWSFPAPPDTSVPQUZWYMXUZUHSXEPYEPOPPZSZUFPOMBZWPFUPZHMDJUDTMOHMQ']';
tabulate(ciphertext)
str = 'UZQSOVUOHXMOPVGPOZPEVSGZWSZOPFPESXUDBMETSXAIZVUEPHZHMDZSHZQWSFPAPPDTSVPQUZWYMXUZUHSXEPYEPOPPZSZUFPOMBZWPFUPZHMDJUDTMOHMQ'; 
n = 2;  
double_letters = cellstr(reshape(str,[],n));
freq_table = tabulate(double_letters); 
disp(freq_table);
str = strrep(str,'P','e');   %出现频率最高
str = strrep(str,'Z','t');
str = strrep(str,'U','i');   %Ut在首，推测U替换i
str = strrep(str,'O','s')    %e附近经常出没O，推测为s(se,es)

str = strrep(str,'E','r')    %形似yesterday
str = strrep(str,'G','y')
str = strrep(str,'V','d')

str = strrep(str,'S','a')    %推测QSs为was
str = strrep(str,'Q','w')    

str = strrep(str,'W','h')    %tWha推测为that
str = strrep(str,'H','c')    %direHt推测为direct

str = strrep(str,'X','l')    %seFeraX推测为several
str = strrep(str,'F','v')

str = strrep(str,'Y','p')    %reYreseetative推测为representative

str = strrep(str,'D','n')    %have been/seen
str = strrep(str,'M','o')    %pMlitical推测为political 

str = strrep(str,'T','m')    %结尾地名推测为Moscow

str = strrep(str,'B','f')    %inBormal推测为informal

str = strrep(str,'A','b')    %两个形容词之间用and/but，由当前密文三个字母含t同时满足been，得知用b
str = strrep(str,'I','u')    
 
str = strrep(str,'J','g')    %vietconJ in Moscow 推测J为g