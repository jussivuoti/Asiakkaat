<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Autojen listaus</title>
</head>
<body>
	<table id="listaus">
		<thead>
			<tr>
				<th colspan="5" class="oikealle"><span id="uusiAsiakas">Lisää
						uusi asiakas</span></th>
			</tr>
			<tr>
				<th colspan="3" class="oikealle">Hakusana:</th>
				<th><input type="text" id="hakusana"></th>
				<th><input type="button" id="hae" value="Hae"></th>
			</tr>
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>
				<th>&nbsp;</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<script>
		haeTiedot();
		document.getElementById("hakusana").focus();//viedään kursori hakusana-kenttään sivun latauksen yhteydessä

		function tutkiKey(event) {
			if (event.keyCode == 13) {//Enter
				haeTiedot();
			}
		}

		function haeTiedot() {
			document.getElementById("tbody").innerHTML = "";
			fetch("asiakkaat/" + document.getElementById("hakusana").value, {//Lähetetään kutsu backendiin
				method : 'GET'
			})
					.then(function(response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
						return response.json()
					})
					.then(
							function(responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
								var asiakkaat = responseJson.asiakkaat;
								var htmlStr = "";
								for (var i = 0; i < asiakkaat.length; i++) {
									htmlStr += "<tr>";
									htmlStr += "<td>" + asiakkaat[i].etunimi
											+ "</td>";
									htmlStr += "<td>" + asiakkaat[i].sukunimi
											+ "</td>";
									htmlStr += "<td>" + asiakkaat[i].puhelin
											+ "</td>";
									htmlStr += "<td>" + asiakkaat[i].sposti
											+ "</td>";
									htmlStr += "<td><a href='muutaasiakas.jsp?asiakas_id="
											+ asiakkaat[i].asiakas_id
											+ "'>Muuta</a>&nbsp;";
									htmlStr += "<span class='poista' onclick=poista('"
											+ asiakkaat[i].asiakas_id
											+ "')>Poista</span></td>";
									htmlStr += "</tr>";
								}
								document.getElementById("tbody").innerHTML = htmlStr;
							})

			/* VANHA KOODI
			$("#listaus tbody").empty();
			$.getJSON({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){	
				$.each(result.asiakkaat, function(i, field){  
			    	var htmlStr;
			    	htmlStr+="<tr id='rivi_"+field.asiakas_id+"'>";
			    	htmlStr+="<td>"+field.etunimi+"</td>";
			    	htmlStr+="<td>"+field.sukunimi+"</td>";
			    	htmlStr+="<td>"+field.puhelin+"</td>";
			    	htmlStr+="<td>"+field.sposti+"</td>";
			    	htmlStr+="<td><a href='muutaasiakas.jsp?asiakas_id="+field.asiakas_id+"'>Muuta</a>&nbsp;";
			    	htmlStr+="<span class='poista' onclick=poista("+field.asiakas_id+",'"+field.etunimi+"','"+field.sukunimi+"')>Poista</span></td>"; 
			    	htmlStr+="</tr>";
			    	$("#listaus tbody").append(htmlStr);
			    });
			}});*/
		}

		function poista(asiakas_id) {
			if (confirm("Poista asiakas " + etunimi + "?")) {
				fetch("asiakkaat/" + asiakas_id, {//Lähetetään kutsu backendiin
					method : 'DELETE'
				})
						.then(function(response) {//Odotetaan vastausta ja muutetaan JSON-vastaus objektiksi
							return response.json()
						})
						.then(
								function(responseJson) {//Otetaan vastaan objekti responseJson-parametrissä		
									var vastaus = responseJson.response;
									if (vastaus == 0) {
										document.getElementById("ilmo").innerHTML = "Asiakkaan poisto epäonnistui.";
									} else if (vastaus == 1) {
										document.getElementById("ilmo").innerHTML = "Asiakkaan "
												+ Etunimi + " poisto onnistui.";
										haeTiedot();
									}
									setTimeout(
											function() {
												document.getElementById("ilmo").innerHTML = "";
											}, 5000);
								})
			}
		}

		/*VANHA POISTO	function poista(asiakas_id, etunimi, sukunimi){
		 if(confirm("Poista asiakas " + etunimi +" "+ sukunimi +"?")){	
		 $.ajax({url:"asiakkaat/"+asiakas_id, type:"DELETE", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"}
		 if(result.response==0){
		 $("#ilmo").html("Asiakkaan poisto epäonnistui.");
		 }else if(result.response==1){
		 $("#rivi_"+asiakas_id).css("background-color", "red"); //Värjätään poistetun asiakkaan rivi
		 alert("Asiakkaan " + etunimi +" "+ sukunimi +" poisto onnistui.");
		 haeTiedot();        	
		 }
		 }});
		 }
		 }*/
	</script>
</body>
</html>