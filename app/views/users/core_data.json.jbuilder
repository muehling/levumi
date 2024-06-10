json.groupInfo @login.get_home_info
json.partial! partial: 'users/login', login: @login
json.masquerade @masquerade
json.states states_to_array
json.schoolTypes schooltypes_to_array
json.focusTypes focustypes_to_array
json.accountTypes accounttypes_to_array
json.annotationCategories annotation_categories
json.testTypes TestType.all
json.testMetaData Test.tests_meta
