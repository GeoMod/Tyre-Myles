//
//  NewTireView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/24/21.
//

import SwiftUI

struct NewTireView: View {

	enum Season {
		case winter
		case summer
	}

	@State private var name = ""
	@State private var season: Season = .summer
	@State private var size = ""
	@State private var installDate = Date()
	@State private var removalDate = Date()
	@State private var installDistance = ""
	@State private var removalDistance = ""

	
    var body: some View {
		NavigationView {
			VStack(alignment: .leading) {
				Text("Tire Type")
					.padding([.top, .leading])
					.font(.title2)
				Picker("Season", selection: $season) {
					Text("Summer")
						.tag(Season.summer)
					Text("Winter")
						.tag(Season.winter)
				}
				.padding([.leading, .trailing])
				.pickerStyle(.segmented)

				Group {
					TextField("name", text: $name, prompt: Text("Tire Name"))
					TextField("size", text: $size, prompt: Text("Size (in/cm)"))
						.keyboardType(.numberPad)
				}
				.textFieldStyle(.roundedBorder)
				.padding([.top, .leading, .trailing])


	//			TextField("install date", text: $installDate, prompt: Text("Install Date"))
	//			TextField("removal date", text: $removalDate, prompt: Text("Removal Date"))

				Spacer()
			}

		.navigationTitle("Add New Tire")
		}
//		.navigationBarTitleDisplayMode(.inline)

    }
}

struct NewTireView_Previews: PreviewProvider {
    static var previews: some View {
        NewTireView()
    }
}
