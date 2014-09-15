$(function() {
	"use strict";
	
	function getAPrioriRisk(trisomyType, gestAgeWeeks, gestAgeDays, matAgeYears, matAgeMonths) {
		$.ajax({
			type : 'GET',
			url : '/scripts/aPriori/run',
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
				$('#trisomyChance').html(data.risk);
				$('#showResult').attr('style', 'display:block');
				$('#apriori').attr('style', '');
				
				$('#llimResult').html(data.lower);
				$('#ulimResult').html(data.upper);
				$('#varcofResult').html(data.varcof);
				$('#zscoreResult').html(data.z);
				$('#aprioriResult').html(Math.round(1 / data.aPriori));
			}
		});
	}
	
	jQuery.validator.setDefaults({
		  debug: true,
		  success: "valid"
		});

	$('#main-form').validate();
	$('#lookup-form').validate();
	
	$(function() {
//		$('#calculate-risk-btn').click(function(e) {
//			e.preventDefault();
//			e.stopPropagation();
//
//			$('#showResult').attr('style', 'display:none');
////			if ($('#llim').val() < 0 || 100 < $('#llim').val()) {
////				molgenis.createAlert([ {
////					'message' : 'Lower limit fetal DNA must have a value between 0 and 100%.'
////				} ], 'error');
////			} else if ($('#ulim').val() < 0 || 100 < $('#ulim').val()) {
////				molgenis.createAlert([ {
////					'message' : 'Upper limit fetal DNA must have a value between 0 and 100%.'
////				} ], 'error');
////			} else if ($('#varcof').val() < 0 || 100 < $('#varcof').val()) {
////				molgenis.createAlert([ {
////					'message' : 'Variation coefficient must have a value between 0 and 100%.'
////				} ], 'error');
////			} else if ($('#zscore').val() < -5 || 40 < $('#zscore').val()) {
////				molgenis.createAlert([ {
////					'message' : 'Observed Z score must have a value -5 and 40.'
////				} ], 'error');
////			} else if ("" === $('#apriori').val() || $('#apriori').val() <= 0) {
////				molgenis.createAlert([ {
////					'message' : 'A priori risk of trisomy must have a positive value.'
////				} ], 'error');
////			} else {
//				$('#showResult').attr('style', 'display:block');
////				var apriori = 1 / $('#apriori').val();
//				$('#results').html(getRisk($('#llim').val(), $('#ulim').val(), $('#varcof').val(), $('#zscore').val(), $('#apriori').val()));
//			}
//		});
		
		$('#calculate-a-priori-risk-btn').click(function(e) {
			e.preventDefault();
			e.stopPropagation();
			
//			if ($('#gestAgeWeeks').val() < 10 || 40 < $('#gestAgeWeeks').val()) {
//				molgenis.createAlert([ {
//					'message' : 'Gestational weeks must have a value between 10 and 40.'
//				} ], 'error');
//				
//				$('@aPriori').val('');
//				$('@aPriori').attr('style', 'background-color:#fff');
//			} else if ($('#gestAgeDays').val() < 0 || 6 < $('#gestAgeDays').val()) {
//				molgenis.createAlert([ {
//					'message' : 'Gestational days must have a value between 0 and 6.'
//				} ], 'error');
//				
//				$('@aPriori').val('');
//				$('@aPriori').attr('style', 'background-color:#fff');
//			} else if ($('#matAgeYears').val() < 20 || 44 < $('#matAgeYears').val()) {
//				molgenis.createAlert([ {
//					'message' : 'Maternal years must have a value between 20 and 44.'
//				} ], 'error');
//				
//				$('@aPriori').val('');
//				$('@aPriori').attr('style', 'background-color:#fff');
//			} else if ($('#matAgeMonths').val() < 0 || 11 < $('#matAgeMonths').val()) {
//				molgenis.createAlert([ {
//					'message' : 'Maternal months must have a value between 0 and 11.'
//				} ], 'error'); // to do is case: 44 years > 0 months; same for gest age 
//				
//				$('@aPriori').val('');
//				$('@aPriori').attr('style', 'background-color:#fff');
//			} else {
				getAPrioriRisk($('#trisomyType .active').val(), $('#gestAgeWeeks').val(), $('#gestAgeDays').val(), $('#matAgeYears').val(), $('#matAgeMonths').val());
//			}
		});
	});
});
