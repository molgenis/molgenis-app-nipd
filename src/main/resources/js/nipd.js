$(function() {
	"use strict";
	
	function getAPrioriRisk(trisomyType, gestAgeWeeks, gestAgeDays, matAgeYears, matAgeMonths) {
		$.ajax({
			type : 'GET',
			url : '/scripts/niptAPrioriRisk/run',
			data : {'chrom': trisomyType, 'gaw': gestAgeWeeks, 'gad': gestAgeDays, 'may': matAgeYears, 'mam': matAgeMonths},
			dataType : 'json',
			success : function(data) {
				$('#main-panel').collapse('toggle');
				$('#lookup').collapse('toggle');
				
				$('#aPriori').val(data.aPriori);
				if ("?" == data) {
					$('#aPriori').attr('style', 'background-color:#d9534f');
				} else {
					$('#aPriori').attr('style', 'background-color:#dff0d8');
				}
			}
		});
	}

	function getRisk(llim, ulim, varcof, zscore, apriori) {
		$.ajax({
			type : 'GET',
			url : '/scripts/niptRisk/run',
			data :  {'lower': llim, 'upper': ulim, 'varcof': varcof, 'z' : zscore, 'aPriori' : apriori},
			dataType : 'json',
			success : function(data) {
				$('#resultsPanel').attr('style', 'visibility:visible');
				$('#trisomyChance').html(data.risk + ' %');

				$('#llimResult').html(data.lower + ' %');
				$('#ulimResult').html(data.upper + ' %');
				$('#varcofResult').html(data.varcof + ' %');
				$('#zscoreResult').html(data.z + ' %');
				$('#aprioriResult').html(data.aPriori + ' cases');
			}
		});
	}
	
	function validateGestationAge() {
		if (7 * 40 < 7 * parseFloat($('#gestAgeWeeks').val()) + parseFloat($('#gestAgeDays').val())) {
			$('#gestAge').show();
			return false;
		} else {
			$('#gestAge').hide();
			return true;
		}
	}
	
	function validateMaternalAge() {
		if (12 * 44 < 12 * parseFloat($('#matAgeYears').val()) + parseFloat($('#matAgeMonths').val())) {
			$('#matAge').show();
			return false;
		} else {
			$('#matAge').hide();
			return true;
		}
	}
	
	$('#main-form').validate();
	$('#lookup-form').validate();	
	
	$(function() {

		$('#calculate-risk-btn').click(function(e) {	
			e.preventDefault();
			e.stopPropagation();
			getRisk($('#llim').val(), $('#ulim').val(), $('#varcof').val(), $('#zscore').val(), $('#aPriori').val());
		});
	
		
		$('#calculate-a-priori-risk-btn').click(function(e) {
			e.preventDefault();
			e.stopPropagation();
			if (!validateGestationAge() || !validateMaternalAge()) {
				return;
			}
			getAPrioriRisk($('input:radio[name=LookUpTrisomyTypeRadio]:checked').val(), $('#gestAgeWeeks').val(), $('#gestAgeDays').val(), $('#matAgeYears').val(), $('#matAgeMonths').val());
		});
	});
});
