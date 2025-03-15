{{ partial("layout_partials/base_form",['fields':settingsForm,'id':'frm_Settings'])}}

<script type="text/javascript">
  $(document).ready(function () {
    // populate form
    mapDataToFormUI({
      frm_Settings: '/api/certwardenclient/settings/get',
    }).done(function (data) {});

    // save form and update config file
    $('#saveAct').click(function () {
      $('[id*="saveAct_progress"]').each(function () {
        $(this).addClass('fa fa-spinner fa-pulse');
      });

      saveFormToEndpoint(
        '/api/certwardenclient/settings/set',
        'frm_Settings',
        function () {
          // reload service
          ajaxCall(
            (url = '/api/certwardenclient/service/reload'),
            (sendData = {}),
            (callback = function (data, status) {
              // TODO: add a nice success message or something
              $('[id*="saveAct_progress"]').each(function () {
                $(this).removeClass('fa fa-spinner fa-pulse');
              });
            })
          );
        }
      );
    });

    // update Certificate in Trust Store
    $('#updateCertAct').SimpleActionButton({
      onAction: function (data) {
        console.log(data);
        if (data['status'] == 'ok') {
          BootstrapDialog.show({
            type: BootstrapDialog.TYPE_INFO,
            title: "{{ lang._('Cert Warden Cert Update Result') }}",
            message: "{{ lang._('Update completed.') }}",
            draggable: true,
          });
        }
      },
    });

    // test connection to Cert Warden
    $('#testConnAct').SimpleActionButton({
      onAction: function (data) {
        if (data['status'] == 'ok') {
          BootstrapDialog.show({
            type: BootstrapDialog.TYPE_INFO,
            title: "{{ lang._('Cert Warden Connectivity Result') }}",
            message: "{{ lang._('Cert Warden server responded as healthy.') }}",
            draggable: true,
          });
        }
      },
    });

    // unlink the Cert Warden cert from the Trust Store (so it can be deleted)
    $('#unlinkCertAct').SimpleActionButton({
      onAction: function (data) {
        if (data['status'] == 'ok') {
          BootstrapDialog.show({
            type: BootstrapDialog.TYPE_INFO,
            title: "{{ lang._('Cert Warden Cert Unlink') }}",
            message: "{{ lang._('Cert Warden is no longer linked to the certificate in the Trust store.') }}",
            draggable: true,
          });
        }
      },
    });
  });
</script>

<div class="col-md-12">
  <button class="btn btn-primary" id="saveAct" type="button">
    <b>{{ lang._('Save') }}</b>
    <i id="saveAct_progress" class=""></i>
  </button>

  <button
    class="btn btn-primary"
    id="updateCertAct"
    data-endpoint="/api/certwardenclient/service/update_cert"
    data-label="{{ lang._('Update Cert') }}"
  ></button>

  <button
    class="btn btn-secondary"
    id="testConnAct"
    data-endpoint="/api/certwardenclient/service/connection_test"
    data-label="{{ lang._('Connection Test') }}"
  ></button>

  <button
    class="btn btn-secondary"
    id="unlinkCertAct"
    data-endpoint="/api/certwardenclient/settings/unlink_cert"
    data-label="{{ lang._('Unlink Certificate') }}"
  >
    <i id="unlinkCertAct_progress" class=""></i>
  </button>
</div>
