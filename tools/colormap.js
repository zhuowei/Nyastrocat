var a = document.getElementsByTagName("td");
var colorMap = {};
var colorArr = [];
for (var i = 0; i < a.length; i++) {
    var b = a[i];
    if (a[i].title == "") continue;
    var parts = a[i].title.split("\n");
    var val = parseInt(parts[0].substring(9), 16);
    var rgb = parseInt(parts[1].substring(6), 16);
    console.log(val.toString(16) + ":" + rgb.toString(16));
    colorMap[rgb] = val;
    colorArr.push({"p":val, "c":rgb});
}
//console.log(colorMap);
prompt("", JSON.stringify(colorArr));

