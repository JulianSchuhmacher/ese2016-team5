<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:import url="template/header.jsp" />

<script src="/js/jquery.ui.widget.js"></script>
<script src="/js/jquery.iframe-transport.js"></script>
<script src="/js/jquery.fileupload.js"></script>
<script src="/js/jquery-ui-timepicker-addon.js"></script>

<script src="/js/pictureUploadEditAd.js"></script>

<script src="/js/editAd.js"></script>


<script>
	$(document).ready(function() {		
		$("#field-city").autocomplete({
			minLength : 2
		});
		$("#field-city").autocomplete({
			source : <c:import url="getzipcodes.jsp" />
		});
		$("#field-city").autocomplete("option", {
			enabled : true,
			autoFocus : true
		});
		$("#field-moveInDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#field-moveOutDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		
		$("#field-visitDay").datepicker({
			dateFormat : 'dd-mm-yy'
		});
				
		$("#addVisitButton").click(function() {
			var date = $("#field-visitDay").val();
			if(date == ""){
				return;
			}
			
			var startHour = $("#startHour").val();
			var startMinutes = $("#startMinutes").val();
			var endHour = $("#endHour").val();
			var endMinutes = $("#endMinutes").val();
			
			if (startHour > endHour) {
				alert("Invalid times. The visit can't end before being started.");
				return;
			} else if (startHour == endHour && startMinutes >= endMinutes) {
				alert("Invalid times. The visit can't end before being started.");
				return;
			}
			
			var newVisit = date + ";" + startHour + ":" + startMinutes + 
				";" + endHour + ":" + endMinutes; 
			var newVisitLabel = date + " " + startHour + ":" + startMinutes + 
			" to " + endHour + ":" + endMinutes; 
			
			var index = $("#addedVisits input").length;
			
			var label = "<p>" + newVisitLabel + "</p>";
			var input = "<input type='hidden' value='" + newVisit + "' name='visits[" + index + "]' />";
			
			$("#addedVisits").append(label + input);
		});
                
                // Offer Type
                function offerTypeShowProperFields(type) {
                    console.log(type);
                    $('.ot-rent, .ot-auction, .ot-direct').hide();
                    $('.' + type).show();
                }
                
                // Set on click
                $('#type-rent, #type-auction, #type-direct').click(function() {
                    var showType = 'ot-' + $(this).attr('id').replace('type-', '');
                    offerTypeShowProperFields(showType);
                });
                
                // Set on load
                var offerType = ${ad.offerType};
                var showType;
                if (offerType === 0) showType = 'ot-rent';
                if (offerType === 1) showType = 'ot-auction';
                if (offerType === 2) showType = 'ot-direct';
                offerTypeShowProperFields(showType);

                // Auction Ending Date
                $('#field-auctionEndingDate').datetimepicker({
                    dateFormat : 'dd-mm-yy',
                    hour: (new Date()).getHours()
                });
	});
</script>

<!-- format the dates -->
<fmt:formatDate value="${ad.moveInDate}" var="formattedMoveInDate"
	type="date" pattern="dd-MM-yyyy" />
<fmt:formatDate value="${ad.moveOutDate}" var="formattedMoveOutDate"
	type="date" pattern="dd-MM-yyyy" />
<fmt:formatDate value="${ad.auctionEndingDate}" var="formattedAuctionEndingDate"
	type="date" pattern="dd-MM-yyyy HH:mm" />
	
<pre><a href="/">Home</a>   &gt;   <a href="/profile/myRooms">My Rooms</a>   &gt;   <a href="/ad?id=${ad.id}">Ad Description</a>   &gt;   Edit Ad</pre>


<h1>Edit Ad</h1>
<hr />

<form:form method="post" modelAttribute="placeAdForm"
	action="/profile/editAd" id="placeAdForm" autocomplete="off"
	enctype="multipart/form-data">

<input type="hidden" name="adId" value="${ad.id }" />


        <fieldset>
            <legend>General info</legend>
            <table class="placeAdTable">
                <tr>
                    <td>
                        <label for="field-title">Ad Title</label>
                        <form:input id="field-title" path="title" value="${ad.title}" />
                        <form:errors path="title" cssClass="validationErrorText" />
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <label for="type-rent">Offer Type:</label>
                        <c:choose>
                            <c:when test="${ad.offerType == 0}">
                                <form:radiobutton id="type-rent" path="offerType" value="0" checked="checked" />Rent
                                <form:radiobutton id="type-auction" path="offerType" value="1" />Auction
                                <form:radiobutton id="type-direct" path="offerType" value="2" />Direct
                            </c:when>
                            <c:when test="${ad.offerType == 1}">
                                <form:radiobutton id="type-rent" path="offerType" value="0" />Rent
                                <form:radiobutton id="type-auction" path="offerType" value="1" checked="checked" />Auction
                                <form:radiobutton id="type-direct" path="offerType" value="2" />Direct
                            </c:when>
                            <c:when test="${ad.offerType == 2}">
                                <form:radiobutton id="type-rent" path="offerType" value="0" />Rent
                                <form:radiobutton id="type-auction" path="offerType" value="1" />Auction
                                <form:radiobutton id="type-direct" path="offerType" value="2" checked="checked" />Direct
                            </c:when>
                        </c:choose>
                    </td>
                    <td>
                        <label for="type-room">Property Type:</label>
                        <c:choose>
                            <c:when test="${ad.studio == 'true'}">
                                <form:radiobutton id="type-studio" path="studio" value="1" checked="checked" />Studio
                                <form:radiobutton id="type-room" path="studio" value="0" />Room
                            </c:when>
                            <c:otherwise>
                                <form:radiobutton id="type-room" path="studio" value="0" checked="checked" />Room
                                <form:radiobutton id="type-studio" path="studio" value="1" />Studio
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="field-street">Street *</label>
                        <form:input id="field-street" path="street" value="${ad.street}" />
                        <form:errors path="street" cssClass="validationErrorText" />
                    </td>
                    <td>
                        <label for="field-city">City / Zip code *</label>
                        <form:input id="field-city" path="city" value="${ad.zipcode} - ${ad.city}" />
                        <form:errors path="city" cssClass="validationErrorText" />
                    </td>
                </tr>
                <tr>
                <tr class="ot-rent">
                    <td>
                        <label for="moveInDate">Move-in date *</label>
                        <form:input type="text" id="field-moveInDate" path="moveInDate" value="${formattedMoveInDate}" />
                        <form:errors path="moveInDate" cssClass="validationErrorText" />
                    </td>
                    <td>
                        <label for="moveOutDate">Move-out date (optional)</label>
                        <form:input type="text" id="field-moveOutDate" path="moveOutDate" value="${formattedMoveOutDate}" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="ot-rent">
                            <label for="field-price">Price per month *</label>
                            <form:input id="field-price" type="number" path="price" placeholder="Price per month" step="50" value="${ad.pricePerMonth}" />
                            <form:errors path="price" cssClass="validationErrorText" />
                        </span>
                        <span class="ot-direct">
                            <label for="field-DirectBuyPrice">Price *</label>
                            <form:input id="field-DirectBuyPrice" type="number" path="directBuyPrice" placeholder="Price" step="50" value="${ad.directBuyPrice}" />
                            <form:errors path="directBuyPrice" cssClass="validationErrorText" />
                        </span>
                        <span class="ot-auction">
                            <label for="field-StartingPrice">Starting price</label>
                            <form:input id="field-StartingPrice" type="number" path="auctionStartingPrice" placeholder="Starting price" step="50" value="${ad.auctionStartingPrice}" />
                        </span>
                    </td>
                    <td>
                        <span class="ot-auction">
                            <label for="field-auctionEndingDate">Ending Date *</label>
                            <form:input id="field-auctionEndingDate" path="auctionEndingDate" placeholder="Ending Date" value="${formattedAuctionEndingDate}" />
                            <form:errors path="auctionEndingDate" cssClass="validationErrorText" />
                        </span>     
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="field-SquareFootage">Square Meters *</label>
                        <form:input id="field-SquareFootage" type="number" path="squareFootage" value="${ad.squareFootage}" step="5" />
                        <form:errors path="squareFootage" cssClass="validationErrorText" />
                    </td>
                    <td></td>
                </tr>
            </table>
        </fieldset>


	<br />
	<fieldset>
		<legend>Change Room Description</legend>

		<table class="placeAdTable">
			<tr>
				<td>
					<c:choose>
						<c:when test="${ad.smokers}">
							<form:checkbox id="field-smoker" path="smokers" checked="checked" /><label>Smoking
							inside allowed</label>
						</c:when>
						<c:otherwise>
							<form:checkbox id="field-smoker" path="smokers" /><label>Smoking
							inside allowed</label>
						</c:otherwise>
					</c:choose>
				</td>
				
				<td>
					<c:choose>
						<c:when test="${ad.animals}">
							<form:checkbox id="field-animals" path="animals"  checked="checked" /><label>Animals
						allowed</label>
						</c:when>
						<c:otherwise>
							<form:checkbox id="field-animals" path="animals" /><label>Animals
						allowed</label>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<td>
					<c:choose>
						<c:when test="${ad.garden}">
							<form:checkbox id="field-garden" path="garden" checked="checked" /><label>Garden
							(co-use)</label>
						</c:when>
						<c:otherwise>
							<form:checkbox id="field-garden" path="garden" /><label>Garden
							(co-use)</label>
						</c:otherwise>
					</c:choose>
				</td>
				
				<td>
					<c:choose>
						<c:when test="${ad.balcony}">
							<form:checkbox id="field-balcony" path="balcony"  checked="checked" /><label>Balcony
						or Patio</label>
						</c:when>
						<c:otherwise>
							<form:checkbox id="field-balcony" path="balcony" /><label>Balcony
						or Patio</label>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<td>
					<c:choose>
						<c:when test="${ad.cellar}">
							<form:checkbox id="field-cellar" path="cellar" checked="checked" /><label>Cellar
						or Attic</label>
						</c:when>
						<c:otherwise>
							<form:checkbox id="field-cellar" path="cellar" /><label>Cellar
						or Attic</label>
						</c:otherwise>
					</c:choose>
				</td>
				
				<td>
					<c:choose>
						<c:when test="${ad.furnished}">
							<form:checkbox id="field-furnished" path="furnished"  checked="checked" /><label>Furnished
							</label>
						</c:when>
						<c:otherwise>
							<form:checkbox id="field-furnished" path="furnished" /><label>Furnished</label>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<td>
					<c:choose>
						<c:when test="${ad.cable}">
							<form:checkbox id="field-cable" path="cable" checked="checked" /><label>Cable TV</label>
						</c:when>
						<c:otherwise>
							<form:checkbox id="field-cable" path="cable" /><label>Cable TV</label>
						</c:otherwise>
					</c:choose>
				</td>
				
				<td>
					<c:choose>
						<c:when test="${ad.garage}">
							<form:checkbox id="field-garage" path="garage"  checked="checked" /><label>Garage
							</label>
						</c:when>
						<c:otherwise>
							<form:checkbox id="field-garage" path="garage" /><label>Garage</label>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<td>
					<c:choose>
						<c:when test="${ad.internet}">
							<form:checkbox id="field-internet" path="internet"  checked="checked" /><label>WiFi available
							</label>
						</c:when>
						<c:otherwise>
							<form:checkbox id="field-internet" path="internet" /><label>WiFi available</label>
						</c:otherwise>
					</c:choose>
				</td>
				
				<td>
					<c:choose>
						<c:when test="${ad.dishwasher}">
							<form:checkbox id="field-dishwasher" path="dishwasher"  checked="checked" /><label>WiFi available
							</label>
						</c:when>
						<c:otherwise>
							<form:checkbox id="field-dishwasher" path="dishwasher" /><label>WiFi available</label>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>

		</table>
		<br />
		<form:textarea path="roomDescription" rows="10" cols="100" value="${ad.roomDescription}" />
		<form:errors path="roomDescription" cssClass="validationErrorText" />
	</fieldset>

	<br />
	<fieldset>
		<legend>Change preferences</legend>
		<form:textarea path="preferences" rows="5" cols="100"
			value="${ad.preferences}" ></form:textarea>
	</fieldset>

	
	<fieldset>
		<legend>Add visiting times</legend>
		
		<table>
			<tr>
				<td>
					<input type="text" id="field-visitDay" />
					
					<select id="startHour">
 					<% 
 						for(int i = 0; i < 24; i++){
 							String hour = String.format("%02d", i);
							out.print("<option value=\"" + hour + "\">" + hour + "</option>");
 						}
 					%>
					</select>
					
					<select id="startMinutes">
 					<% 
 						for(int i = 0; i < 60; i++){
 							String minute = String.format("%02d", i);
							out.print("<option value=\"" + minute + "\">" + minute + "</option>");
 						}
 					%>
					</select>
					
					<span>to&thinsp; </span>
					
					<select id="endHour">
 					<% 
 						for(int i = 0; i < 24; i++){
 							String hour = String.format("%02d", i);
							out.print("<option value=\"" + hour + "\">" + hour + "</option>");
 						}
 					%>
					</select>
					
					<select id="endMinutes">
 					<% 
 						for(int i = 0; i < 60; i++){
 							String minute = String.format("%02d", i);
							out.print("<option value=\"" + minute + "\">" + minute + "</option>");
 						}
 					%>
					</select>
			

					<div id="addVisitButton" class="smallPlusButton">+</div>
					
					<div id="addedVisits"></div>
				</td>
				
			</tr>
			
		</table>
		<br>
	</fieldset>

	<br />

	<fieldset>
		<legend>Change pictures</legend>
		<h3>Delete existing pictures</h3>
		<br />
		<div>
			<c:forEach items="${ad.pictures }" var="picture">
				<div class="pictureThumbnail">
					<div>
					<img src="${picture.filePath}" />
					</div>
					<button type="button" data-ad-id="${ad.id }" data-picture-id="${picture.id }">Delete</button>
				</div>
			</c:forEach>
		</div>
		<p class="clearBoth"></p>
		<br /><br />
		<hr />
		<h3>Add new pictures</h3>
		<br />
		<label for="field-pictures">Pictures</label> <input
			type="file" id="field-pictures" accept="image/*" multiple="multiple" />
		<table id="uploaded-pictures" class="styledTable">
			<tr>
				<th id="name-column">Uploaded picture</th>
				<th>Size</th>
				<th>Delete</th>
			</tr>
		</table>
		<br>
	</fieldset>

	<div>
		<button type="submit">Submit</button>
		<a href="<c:url value='/ad?id=${ad.id}' />"> 
			<button type="button">Cancel</button>
		</a>
	</div>

</form:form>


<c:import url="template/footer.jsp" />
