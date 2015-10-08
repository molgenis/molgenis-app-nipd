(function ($) {
    "use strict";

    ///////// Main form /////////

    function getInputFromForm() {
        return {
            lower: $('#llim').val(),
            upper: $('#ulim').val(),
            varcof: $('#varcof').val(),
            z: $('#zscore').val(),
            aPriori: $('#aPriori').val()
        };
    }

    function getRisk() {
        var formData = getInputFromForm();
        // retrieve the data used to look up the a priori risk
        var aPrioriLookupData = $('#aPriori').data('lookupFormData');
        $.ajax({
            type: 'GET',
            url: '/scripts/niptRisk/run',
            data: formData,
            dataType: 'json'
        }).then(function (risk) {
            updateRisk(formData, aPrioriLookupData, risk);
        });
    }

    function updateRisk(formData, aPrioriLookupData, risk) {
        $('#resultsPanel').show();
        if (aPrioriLookupData) {
            $('#aPrioriManualResult').hide();
            $('#aPrioriLookupResult').show();
            $('#gestAgeResult').text(aPrioriLookupData.gaw + " weeks " + aPrioriLookupData.gad + " days");
            $('#matAgeResult').text(aPrioriLookupData.may + " years " + aPrioriLookupData.mam + " months");
            $('#trisomyTypeResult').text("Trisomy " + aPrioriLookupData.chrom);
        } else {
            $('#aPrioriManualResult').show();
            $('#aPrioriLookupResult').hide();
        }
        $('#trisomyChance').text(risk.risk + ' %');
        $('#llimResult').text(formData.lower + ' %');
        $('#ulimResult').text(formData.upper + ' %');
        $('#varcofResult').text(formData.varcof + ' %');
        $('#zscoreResult').text(formData.z);
        $('#aprioriResult').text(formData.aPriori + ' cases');
    }

    ///////// A priori risk lookup form //////////

    function getLookupFormData() {
        return {
            'chrom': $('input:radio[name=LookUpTrisomyTypeRadio]:checked').val(),
            'gaw': $('#gestAgeWeeks').val(),
            'gad': $('#gestAgeDays').val(),
            'may': $('#matAgeYears').val(),
            'mam': $('#matAgeMonths').val()
        };
    }

    function getAPrioriRisk() {
        var lookupFormData = getLookupFormData();
        $.ajax({
            type: 'GET',
            url: '/scripts/niptAPrioriRisk/run',
            data: lookupFormData,
            dataType: 'json'
        }).then(function (aPrioriRisk) {
            updateAPrioriRisk(lookupFormData, aPrioriRisk);
        });
    }

    function updateAPrioriRisk(lookupFormData, aPrioriRisk) {
        var $aPriori = $('#aPriori'),
            $mainPanel = $('#main-panel'),
            $lookup = $('#lookup');
        $mainPanel.collapse('show');
        $lookup.collapse('hide');
        $aPriori.val(aPrioriRisk.aPriori);
        // store the form data used to look up this aPrioriRisk
        $aPriori.data('lookupFormData', lookupFormData);
        if (aPrioriRisk === "?") {
            $aPriori.css('background-color', '#d9534f');
        } else {
            $aPriori.css('background-color', '#dff0d8');
        }
    }

    function resetAPrioriLookupData() {
        var $aPriori = $('#aPriori');
        $aPriori.data('lookupFormData', null);
        $aPriori.css('background-color', '');
    }

    ///////////  validation ///////////

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

    /////////// On Load ////////////

    $(function () {
        $('#main-form').validate({
            submitHandler: getRisk
        });

        $('#lookup-form').validate({
            submitHandler: function () {
                if (!validateGestationAge() || !validateMaternalAge()) {
                    return;
                }
                getAPrioriRisk();
            }
        });

        $('#aPriori').on('change keyup paste', resetAPrioriLookupData);
    });
})($);
