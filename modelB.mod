//parameters

//to cells egine 1..6 apo 1..5
range cells = 1..6;
range areas = 1..12;
range type = 1..4;
range dis = 1..3; 

int M = ...;
int qualities[cells][areas] = ...;
int capacityArea[areas] = ...;
int capacityCell[cells] = ...;
float costs[cells][type] = ...;
float coef[cells][type] = ...;
float discounts[dis] = ...;

//decision vars

dvar boolean upgrade[cells][type];
dvar boolean k[areas][cells][type];
dvar boolean typeOfDiscount[dis];

//objective function

dexpr float total_cost = sum(i in cells, j in type) (costs[i][j]*upgrade[i][j]) - sum(d in dis, i in 2..3)(typeOfDiscount[d]*discounts[d]*costs[i][d]);
minimize total_cost; 

//constraints

subject to {

//gia kathe cell theloume to poly enan typo anavathmisis	
forall(i in cells)
 	upgrade_con2:
 	sum(j in type)upgrade[i][j]<=1;	

//kathe perioxh theloume na antistoixitai se ena cell me enan typo anavathmisis 
forall(n in areas)
    k_con:
    sum(i in cells, j in type) k[n][i][j] >= 1 ;

//kathe perioxh theloume na antistoixitai se ena cell me enan typo anavathmisis 
forall(n in areas)
    k_con2:
    sum(i in cells, j in type) k[n][i][j] <= 1; 

//periorismos gia na exoume anavathmish mias perioxis se ena keli 
//theloume na exei enhmerwthei h anavathmish sto idio to keli (dhladh ston pinaka upgrade)    
forall(n in areas)
forall(i in cells, j in type)
    desimo_upgrade_k_con:
    upgrade[i][j] <= 1 + (1-k[n][i][j])*M ;

//periorismos gia na exoume anavathmish mias perioxis se ena keli 
//theloume na exei enhmerwthei h anavathmish sto idio to keli (dhladh ston pinaka upgrade)  
forall(n in areas)
forall(i in cells, j in type)
    desimo_upgrade_k_con2:
    upgrade[i][j] >= 1 + (1-k[n][i][j])*(-M) ;

//periorismos poiothtas ana perioxh
forall(n in areas)
	quality_per_area_con:
	sum(i in cells, j in type) (k[n][i][j] * (trunc(coef[i][j]*qualities[i][n]+qualities[i][n]))) >= 8;
	
//prepei na mhn upervenetai h xwiritikothta tou kathe cell. Dhladh na to athroisma twn xwritikothtwn
//perioxwn pou syndeontai me ena cell prepei na einai mikrothero apo thn xwrotikothta tou cell
forall(i in cells)
    capacity_con:
    sum(n in areas, j in type)(k[n][i][j] * capacityArea[n]) <= capacityCell[i];    

//h xwrithtkothta kathe perioxhs prepei na einai mikroterh h ish ths xwrithkothtas tou cell
// me to opoio syndeetai
forall(n in areas)
	capacity_con2:
    sum(i in cells, j in type)(k[n][i][j]*capacityCell[i]) >= capacityArea[n];

//EKPTWSEIS 

ekptwsh_merikhs_con:
typeOfDiscount[1]<= 1 + (2-(upgrade[2][1]+upgrade[3][1]))*M ; //prepei upgrade[2][1]=upgrade[3][1]=1 wste to typeofDiscount[1]=1 
typeOfDiscount[1]>= 1 + (2-(upgrade[2][1]+upgrade[3][1]))*(-M);

ekptwsh_ektetamenhs_con:
typeOfDiscount[2]<= 1 + (2-(upgrade[2][2]+upgrade[3][2]))*M ;//prepei upgrade[2][2]=upgrade[3][2]=1 wste to typeofDiscount[2]=1
typeOfDiscount[2]>= 1 + (2-(upgrade[2][2]+upgrade[3][2]))*(-M);

ekptwsh_plhrous_con:
typeOfDiscount[3]<= 1 + (2-(upgrade[2][3]+upgrade[3][3]))*M ;//prepei upgrade[2][3]=upgrade[3][3]=1 wste to typeofDiscount[3]=1
typeOfDiscount[3]>= 1 + (2-(upgrade[2][3]+upgrade[3][3]))*(-M);

//den einai dynato na exoume typo ekptwshs xwris na exoume enhmerwsei ton upgrade pinaka
other_discounts_cons:
forall(j in dis)
	typeOfDiscount[j]<= upgrade[2][j];

forall(j in dis)	
	typeOfDiscount[j]<= upgrade[3][j];

type_discount_con:
sum(d in dis) typeOfDiscount[d]<=1;
   
//other_discounts_cons:
//typeOfDiscount[1]<= upgrade[2][1];
//typeOfDiscount[1]<= upgrade[3][1];
//typeOfDiscount[2]<= upgrade[2][2];
//typeOfDiscount[2]<= upgrade[3][2];
//typeOfDiscount[3]<= upgrade[2][3];
//typeOfDiscount[3]<= upgrade[3][3];
//sum(d in dis) typeOfDiscount[d]<=1;
}      
