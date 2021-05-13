<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Insert title here</title>
</head>
<body>
	<form id="tiedot">
		<table>
			<thead>
				<tr>
					<th colspan="5" class="oikealle"><span id="takaisin">Takaisin
							listaukseen</span></th>
				</tr>
				<tr>
					<th>Etunimi</th>
					<th>Sukunimi</th>
					<th>Puhelin</th>
					<th>Sposti</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><input type="text" name="etunimi" id="etunimi"></td>
					<td><input type="text" name="sukunimi" id="sukunimi"></td>
					<td><input type="text" name="puhelin" id="puhelin"></td>
					<td><input type="text" name="sposti" id="sposti"></td>
					<td><input type="button" id="tallenna" value="Tallenna"
						onclick="vieTiedot()"></td>
				</tr>
			</tbody>
		</table>

	</form>
	<span id="ilmo"></span>
</body>
<script>

function tutkiKeyX(event){
	if(event.keyCode==13){//Enter
		vieTiedot();
	}		
}

var tutkiKey = (event) => {
	if(event.keyCode==13){//Enter
		vieTiedot();
	}	
}

document.getElementById("etunimi").focus();//viedään kursori rekno-kenttään sivun latauksen yhteydessä

//Haetaan muutettavan asiakkaan tiedot. Kutsutaan backin GET-metodia ja välitetään kutsun mukana muutettavan tiedon id
//GET /asiakkaat/haeyksi/id
var asiakkaat = requestURLParam("asiakas_id"); //Funktio löytyy scripts/main.js 
fetch("asiakkaat/haeyksi/" + rekno,{//Lähetetään kutsu backendiin
      method: 'GET'	      
    })
.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastausteksti objektiksi
	return response.json()
})
.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
	console.log(responseJson);
	document.getElementById("etunimi").value = responseJson.etunimi;		
	document.getElementById("sukunimi").value = responseJson.sukunimi;	
	document.getElementById("puhelin").value = responseJson.puhelin;	
	document.getElementById("sposti").value = responseJson.sposti;	
	
});	

//Funktio tietojen muuttamista varten. Kutsutaan backin PUT-metodia ja välitetään kutsun mukana muutetut tiedot json-stringinä.
//PUT /autot/
function vieTiedot(){	
	var ilmo = "";
	var d = new Date();
	if (document.getElementById("etunimi").value.length < 3) {
		ilmo = "Etunimi ei kelpaa!";
	} else if (document.getElementById("Sukunimi").value.length < 3) {
		ilmo = "Sukunimi ei kelpaa!";
	} else if (document.getElementById("sposti").value.length < 3) {
		ilmo = "Sähköpostiosoite ei kelpaa!";
	} else if (document.getElementById("puhelin").value.length < 3) {
		ilmo = "Puhelinnumero ei kelpaa!";
	}
	if (ilmo != "") {
		document.getElementById("ilmo").innerHTML = ilmo;
		setTimeout(function() {
			document.getElementById("ilmo").innerHTML = "";
		}, 3000);
		return;
	}
	document.getElementById("etunimi").value = siivoa(document
			.getElementById("etunimi").value);
	document.getElementById("sukunimi").value = siivoa(document
			.getElementById("sukunimi").value);
	document.getElementById("puhelin").value = siivoa(document
			.getElementById("puhelin").value);
	document.getElementById("sposti").value = siivoa(document
			.getElementById("sposti").value);
	
	var formJsonStr=formDataToJSON(document.getElementById("tiedot")); //muutetaan lomakkeen tiedot json-stringiksi
	console.log(formJsonStr);
	//Lähetään muutetut tiedot backendiin
	fetch("asiakkaat",{//Lähetetään kutsu backendiin
	      method: 'PUT',
	      body:formJsonStr
	    })
	.then( function (response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
		return response.json();
	})
	.then( function (responseJson) {//Otetaan vastaan objekti responseJson-parametrissä	
		var vastaus = responseJson.response;		
		if(vastaus==0){
			document.getElementById("ilmo").innerHTML= "Tietojen päivitys epäonnistui";
        }else if(vastaus==1){	        	
        	document.getElementById("ilmo").innerHTML= "Tietojen päivitys onnistui";			      	
		}	
		setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
	});	
	document.getElementById("tiedot").reset(); //tyhjennetään tiedot -lomake
}


/* VANHA KOODI
	$(document).ready(function() {

		$("#takaisin").click(function() {
			document.location = "listaaasiakkaat.jsp";
		});

		var asiakas_id = requestURLParam("asiakas_id");
		$.ajax({
			url : "asiakkaat/haeyksi/" + asiakas_id,
			type : "GET",
			dataType : "json",
			success : function(result) {
				$("#asiakas_id").val(result.asiakas_id);
				$("#etunimi").val(result.etunimi);
				$("#sukunimi").val(result.sukunimi);
				$("#puhelin").val(result.puhelin);
				$("#sposti").val(result.sposti);
			}
		});
		$("#tiedot").validate({						
		rules: {
			etunimi:  {
				required: true,				
				minlength: 2				
			},	
			sukunimi:  {
				required: true,				
				minlength: 2				
			},
			puhelin:  {
				required: true,
				minlength: 5
			},	
			sposti:  {
				required: true,
				email: true				
			}	
		},
		messages: {
			etunimi: {     
				required: "Puuttuu",				
				minlength: "Liian lyhyt"			
			},
			sukunimi: {
				required: "Puuttuu",				
				minlength: "Liian lyhyt"
			},
			puhelin: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			sposti: {
				required: "Puuttuu",
				email: "Ei kelpaa"
			}
		},			
		submitHandler: function(form) {	
			paivitaTiedot();
		}		
	});  
	//Viedään kursori etunimi-kenttään sivun latauksen yhteydessä
	$("#etunimi").focus(); 
});
function paivitaTiedot(){
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //muutetaan lomakkeen tiedot json-stringiksi
	console.log(formJsonStr);
	$.ajax({url:"asiakkaat", data:formJsonStr, type:"PUT", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}       
		if(result.response==0){
        	$("#ilmo").html("Asiakkaan päivittäminen epäonnistui.");
        }else if(result.response==1){			
        	$("#ilmo").html("Asiakkaan päivittäminen onnistui.");
        	$("#etunimi, #sukunimi, #puhelin, #sposti").val("");
		}
    }});	
} */
</script>
</body>
</html>