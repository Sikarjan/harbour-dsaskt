var skt = [[1,1,2,3,4,5,7.5,10,20],
           [1,1,2,2,3,4,6,8,16],
           [2,3,6,8,10,13,20,26,51],
           [3,6,12,17,22,28,42,56,111],
           [5,10,20,30,39,49,74,98,196],
           [9,16,31,47,61,77,115,153,306],
           [14,23,45,68,88,111,165,223,446],
           [20,31,62,93,121,152,225,308,611],
           [28,41,81,122,160,200,300,403,806],
           [37,52,103,156,205,255,385,513,1026],
           [48,65,128,194,255,320,480,638,1276],
           [60,79,156,237,310,390,585,778,1556],
           [74,95,188,284,375,470,705,938,1876],
           [89,112,223,335,445,555,835,1113,2226],
           [106,131,261,390,520,650,975,1303,2606],
           [125,152,302,450,605,755,1130,1513,3016],
           [145,174,347,515,695,865,1295,1733,3466],
           [167,198,395,585,790,985,1475,1973,3946],
           [191,224,446,660,895,1115,1670,2233,4456],
           [216,251,501,740,1005,1250,1880,2503,5006],
           [243,280,559,825,1120,1395,2100,2793,5586],
           [272,311,621,920,1245,1550,2330,3103,6206],
           [303,344,686,1020,1375,1715,2580,3433,6856],
           [335,378,755,1125,1515,1885,2840,3773,7546],
           [369,414,828,1235,1660,2065,3110,4133,8266],
           [405,452,904,1350,1810,2255,3400,4513,9026],
           [443,492,984,1470,1970,2455,3700,4913,9826],
           [483,534,1068,1595,2135,2665,4010,5333,10656],
           [525,578,1155,1725,2305,2885,4340,5773,11526],
           [568,623,1246,1860,2485,3115,4680,6233,12436],
           [613,670,1341,2000,2675,3355,5030,6713,13386],
           [661,720,1441,2150,2875,3605,5405,7213,14386]];

function upgardeCost(column, from, to) {
    return skt[to][column] - skt[from][column];
}