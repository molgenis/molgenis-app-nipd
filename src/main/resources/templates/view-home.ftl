<#include "molgenis-header.ftl">
<#include "molgenis-footer.ftl">

<#assign css=['nipd.css']>
<#assign js=['nipd.js']>

<@header css js/>

<div class="container">
	<div class="row">
		<H1>Non-invasive prenatal testing <a href="http://www.umcg.nl/NL/UMCG/Afdelingen/Genetica/Pages/default.aspx"><img src="/img/umcg.png" /></a></H1>
	</div>

	<div class="row">
		<div class="col-md-8 panel-group" id="parent-collapse">
		<div class="panel panel-primary">
			<div class="panel-heading">
				<h3 class="panel-title">Input</h3>
			</div>
			<div class="panel-body collapse in" id="main-panel">
				<form accept-charset="UTF-8" role="form" class="form-horizontal" id="main-form">
					<div class="form-group">
						<label class="col-md-4 control-label text-muted" for="llim">Lower limit fetal DNA</label>
						<div class="col-md-5">
							<div class="input-group">				
		                		<input id="llim" name="llim" class="form-control" type="text" value="1" data-rule-range="[0,100]" data-rule-number="true" data-msg-number="Please enter a value between 0 and 100%." data-msg-range="Please enter a value between 0 and 100%." required="required">
			                	<div class="input-group-addon">%</div>
			                </div>
			                <label for="llim" class="error" style="display: none"></label>
		                </div>                
					</div>
					<div class="form-group">
						<label class="col-md-4 control-label text-muted" for="ulim">Upper limit fetal DNA</label>
						<div class="col-md-5">
							<div class="input-group">				
		                		<input id="ulim" name="ulim" class="form-control" type="text" value="23" data-rule-range="[0,100]" data-rule-number="true" data-msg-number="Please enter a value between 0 and 100%." data-msg-range="Please enter a value between 0 and 100%." required="required">
			                	<div class="input-group-addon">%</div>
			                </div>
			                <label for="ulim" class="error" style="display: none"></label>
		                </div>                
					</div>
					<div class="form-group">
						<label class="col-md-4 control-label text-muted" for="varcof">Variation coefficient</label>
						<div class="col-md-5">
							<div class="input-group">				
		                		<input id="varcof" name="varcof" class="form-control" type="text" value="0.5" data-rule-range="[0,100]" data-rule-number="true" data-msg-number="Please enter a value between 0 and 100." data-msg-range="Please enter a value between 0 and 100%." required="required">
			                	<div class="input-group-addon">%</div>
			                </div>
			                <label for="varcof" class="error" style="display: none"></label>
		                </div>                
					</div>
					<div class="form-group">
						<label class="col-md-4 control-label text-muted" for="zscore">Observed z-score</label>
						<div class="col-md-5">
							<div class="input">				
		                		<input id="zscore" name="zscore" class="form-control"  type="text" value="4" data-rule-range="[-5,40]" data-rule-number="true" data-msg-number="Please enter a value between -5 and 40." data-msg-range="Please enter a value between -5 and 40." required="required">
			                </div>
			                <label for="zscore" class="error" style="display: none"></label>
		                </div>                
					</div>
					<div class="form-group">
						<label class="col-md-4 control-label text-muted" for="aPriori">A priori risk</label>
						<div class="col-md-5">
							<div class="input-group">				
		                		<div class="input-group-addon">1 in</div>
		                		<input id="aPriori" name="aPriori" class="form-control"  type="text" value="" data-rule-min="1" data-rule-digits="true" data-msg-digits="Please enter a whole number greater than or equal to 1." data-msg-min="Please enter a number greater than or equal to 1." required="required">
			                	<div class="input-group-addon">cases</div>
			                </div>
			                <label for="aPriori" class="error" style="display: none"></label>
		                </div>
	                	<button type="button" class="btn btn-warning" data-toggle="collapse" data-target="#lookup" data-parent="#parent-collapse"><span class="glyphicon glyphicon-list-alt"></span> Look up</button>
	                	<button id='calculate-risk-btn' type='submit' class='btn btn-primary'><b>Go</b> <span class="glyphicon glyphicon-chevron-right"></span></button>
					</div>
				</form>
			</div>

			<div id="lookup" class="collapse">			
				<div class="panel panel-warning">
					<div class="panel-heading" style="background-color:#FAD5A0">
						<h3 class="panel-title">Look up a priori risk</h3>
					</div>
					<div class="panel-body">
						<form accept-charset="UTF-8" role="form" class="form-horizontal" id="lookup-form">
							<div class="form-group">
								<label class="col-md-4 control-label text-muted" for="gestAgeWeeks">Gestational age</label>
								<div class="col-md-5">
									<div class="input-group">				
				                		<input id="gestAgeWeeks" name="gestAgeWeeks" class="form-control" type="text" value="20" data-rule-range="[10,40]" data-rule-digits="true" required="required"><div class="input-group-addon">weeks</div>
				                		<input id="gestAgeDays" name="gestAgeDays" class="form-control" type="text" value="0" data-rule-range="[0,6]" data-rule-digits="true" required="required"><div class="input-group-addon">days</div>
					                </div>
					                <label for="gestAgeWeeks" class="error" style="display: none;"></label>
					                <label for="gestAgeDays"  class="error" style="display: none;"></label>
					                <label id="gestAge" class="error" style="display: none;">Maximum value is 40 weeks and 0 days.</label>
				                </div>                
							</div>
							<div class="form-group">
								<label class="col-md-4 control-label text-muted" for="matAgeYears">Maternal age</label>
								<div class="col-md-5">
									<div class="input-group">
										<input id="matAgeYears" name="matAgeYears"   class="form-control" type="text" value="20" data-rule-range="[20,44]" data-rule-digits="true" required="required"><div class="input-group-addon">years</div>
										<input id="matAgeMonths" name="matAgeMonths" class="form-control" type="text" value="0"  data-rule-range="[0,12]"  data-rule-digits="true" required="required"><div class="input-group-addon">months</div>
									</div>
					                <label for="matAgeYears"  class="error" style="display: none;"></label>
					                <label for="matAgeMonths" class="error" style="display: none;"></label>
					                <label  id="matAge"       class="error" style="display: none;">Maximum value is 44 years and 0 months.</label>
				                </div>
							</div>
							<div class="form-group">
								<label class="col-md-4 control-label text-muted" for="matAgeYears">Type</label>
								<div class="col-md-5">
									<div class="btn-group" role="group">
										<label class="btn btn-default">
											<input type="radio" name="LookUpTrisomyTypeRadio" value="13" checked>&nbsp;&nbsp;T13</input>
										</label>
										<label class="btn btn-default">
											<input type="radio" name="LookUpTrisomyTypeRadio" value="18">&nbsp;&nbsp;T18</input>
										</label>
										<label class="btn btn-default">
											<input type="radio" name="LookUpTrisomyTypeRadio" value="21">&nbsp;&nbsp;T21</input>
										</label>
									</div>
								</div>
								<button type="button" class="btn btn-default" data-toggle="collapse" data-target="#main-panel" data-parent="#parent-collapse">Cancel</button>
								<button id="calculate-a-priori-risk-btn" type="submit" class="btn btn-warning">Look up <span class="glyphicon glyphicon-chevron-right"></span></button>
							</div>
						</form>
					</div>
				</div>
			</div>
			<div style="clear:both"></div>
		</div>
		</div>
		<div class="col-md-4">
			<div class="panel panel-danger">
				<div class="panel-heading">
					<h3 class="panel-title">Result</h3>
				</div>
				<div id="resultsPanel" class="panel-body" style="display:none;">
					<P>The chance on a trisomy is estimated:</P>
					<h2 style="text-align: center"><span id="trisomyChance" class="label label-danger label-as-badge"></span></h2>
					<br/>
					<p>The estimation is based on:</p>
					<table class="table text-muted table-striped table-bordered">
						<tr><td>Lower limit fetal DNA:</td><td><span id="llimResult"></span></td></tr>
						<tr><td>Upper limit fetal DNA:</td><td><span id="ulimResult"></span></td></tr>
						<tr><td>Variation coefficient:</td><td><span id="varcofResult"></span></td></tr>
						<tr><td>Observed z-score:</td><td><span id="zscoreResult"></span></td></tr>
						<tr><td>A priori risk: 1 in</td><td><span id="aprioriResult"></span></td></tr>
					</table>
					<div id="aPrioriManualResult">
						<p>The a priori risk was entered <b>manually</b>.</p>
					</div>
					<div id="aPrioriLookupResult">
						<p>The a priori risk was based on:</p>
						<table class="table text-muted table-striped table-bordered">
							<tr><td>Gestational age:</td><td><span id="gestAgeResult"></span></td></tr>
							<tr><td>Maternal age:</td><td><span id="matAgeResult"></span></td></tr>
							<tr><td>Type:</td><td><b><span id="trisomyTypeResult" style="color: black;"></span></b></td></tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col col-md-12 alert alert-info" role="alert">
			<p>Please make sure to read the <button class="btn btn-warning" data-toggle="modal" data-target="#disclaimer">Warnings</button>.
			See the <a href="https://molgenis26.target.rug.nl/downloads/20140605_ppvfornipt_UserManual.pdf" target="_blank">user manual</a> or contact <a href="mailto:g.j.te.meerman@umcg.nl" target="_top">G.J. te Meerman</a> for further information.</p>
		</div>
	</div>
	
	<div class="modal fade" id="disclaimer">
  		<div class="modal-dialog">
		    <div class="modal-content panel-warning">
		      <div class="modal-header panel-heading">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h3 class="modal-title">Warning</h3>
		      </div>
		      <div class="modal-body">
		        <h4>Using the tool, please keep the following in mind:</h4>
				<p>The result of the calculation is an estimation, not an exact number.</p>
				<p>The calculations are primarily made for a trisomy 13, 18 or 21 and will not exclude other chromosomal aberrations.</p>
				<p>The user is responsible for the input parameters, i.e. a high Z score in combination with a low percentage of DNA might reflect a &ldquo;failed&rdquo; test in which case the tool is not usable.</p>
				<p>A patient with a positive or high risk score should be referred for genetic counseling and offered invasive prenatal diagnosis for confirmation of test results. This result may occur due to placental, maternal, or fetal mosaicism or neoplasm; vanishing twin and in these cases will not reflect the fetus.</p>
				<p>A negative or low risk score does not ensure an unaffected pregnancy.</p>
				<p>Management decisions, including termination of the pregnancy, should not be based on the results of this test alone.</p>
				<p>The results of this test, including its benefits and limitations, should be discussed with a qualified healthcare professional.</p>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		      </div>
		    </div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
</div>
<@footer/>