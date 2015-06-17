/*
 * Show edit/add attendance form
 */
function showEditAttendanceForm(obj, id, year, month, day) {
    var url = '/attendance/edit/' + id + '/' + year + '/' + month + '/' + day;
    $('#edit-attendance').modal({
        keyboard: true,
        remote: url
    });
}

/*
 * Validate all input before form is submitted
 */
function validateAttendanceForm() {
    var $form = $('#edit-attendance-form');
    if ($form) {
        //Hours
        if ($form.find('select[name="absent_type"] :selected').val() == 'time') {
            if ($.trim($form.find('input[name="from_hour"]').val()) == '') {
                $form.find('input[name="from_hour"]').focus();
                return false;
            }
            if ($.trim($form.find('input[name="to_hour"]').val()) == '') {
                $form.find('input[name="to_hour"]').focus();
                return false;
            }
        }
        //Content
        if ($.trim($form.find('textarea[name="content"]').val()) == '') {
            $form.find('textarea[name="content"]').focus();
            return false;
        }
    }
    return true;
}

/*
 * Submit attendance form
 */
function submitAttendance() {
    var $form = $('#edit-attendance-form');
    if ($form) {
        $form.submit();
    }
}

/*
 * Switch time input text from editable to uneditable and vise verse
 */
function changeAbsentTypeHandler(obj) {
    var $form = $('#edit-attendance-form');
    var $selectedElement = $form.find('select[name="absent_type"] :selected');
    var selectedOption = $selectedElement.val();
    var $fromHour = $form.find("input[name='from_hour']");
    var $toHour = $form.find("input[name='to_hour']");

    if (selectedOption == 'time') {
        //Enable 2 inputs for entering times
        $fromHour.removeAttr('readonly');
        $toHour.removeAttr('readonly');
    } else {
        //Disable 2 inputs for entering times
        $fromHour.attr('readonly', 'readonly');
        $toHour.attr('readonly', 'readonly');
    }
}