const initialFormData = {
  agency: {
    name: '',
    url: '',
    timezone: '',
    primaryLang: '',
    phoneNum: '',
    fareUrl: '',
    email: '',
  },
  stops: [
    {
      code: '',
      name: '',
      desc: '',
      latitude: '',
      longitude: '',
      wheelchairBoarding: false,
    },
  ],
  routes: [{
    shortName: '',
    longName: '',
    description: '',
    type: ''
  }]
};

export default initialFormData;
