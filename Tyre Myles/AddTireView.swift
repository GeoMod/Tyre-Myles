//
//  NewTireView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/24/21.
//

import SwiftUI

struct AddTireView: View {
	enum Field {
		case name
		case install
		case removal
	}

	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var dataModel: DataModel

	@State private var name = ""
	@State private var seasonType: TireType = .allSeason
	@State private var installDate = Date()
	@State private var removalDate = Date()
	@State private var installMiles = ""
	@State private var removalMiles = ""

	@FocusState private var focusedField: Field?


	var body: some View {
		VStack {
			Text("Tire Type")
				.padding([.top, .leading])
				.font(.title2)
			Picker("Season", selection: $seasonType) {
				Text("Summer")
					.tag(TireType.summer)
				Text("All Season")
					.tag(TireType.allSeason)
				Text("Winter")
					.tag(TireType.winter)
			}
			.padding([.leading, .trailing])
			.pickerStyle(.segmented)

			Group {
				TextField("Tire Name", text: $name)
					.focused($focusedField, equals: .name)
					.keyboardType(.alphabet)
					.submitLabel(.next)
					.padding(.top, 10)
				TextField("Install Distance", text: $installMiles)
					.focused($focusedField, equals: .install)
					.keyboardType(.numbersAndPunctuation)
					.submitLabel(.next)
				TextField("Removal Distance", text: $removalMiles)
					.focused($focusedField, equals: .removal)
					.keyboardType(.numbersAndPunctuation)
					.submitLabel(.done)
			}
			.textFieldStyle(.roundedBorder)
			.padding([.leading, .trailing])

			Group {
				Text("Enter Date Values")
					.font(.title2)
					.padding(.top, 40)
				DatePicker("Install Date", selection: $installDate, displayedComponents: .date)
				DatePicker("Removal Date", selection: $removalDate, displayedComponents: .date)
			}.padding([.leading, .trailing])

			Spacer()

			Button {
				save()
			} label: {
				Capsule()
					.frame(height: 50)
					.overlay(Text("Save")
								.font(.title2.bold())
								.foregroundColor(.white)
					)
			}
			.foregroundStyle(LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .bottom))
			.padding([.leading, .trailing], 40)
		}
		.navigationTitle("Add New Tire")
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Cancel", role: .cancel) {
					cancel()
				}
			}
		}

		.onSubmit {
			switch focusedField {
				case .name:
					focusedField = .install
				case .install:
					focusedField = .removal
				case .removal:
					focusedField = nil
				case .none:
					focusedField = nil
			}
		}


	}

	private func save() {
		dataModel.saveTireProfileWith(name: name, season: seasonType, installMiles: installMiles,
									  removalMiles: removalMiles, installDate: installDate,
									  removallDate: removalDate)
		dismiss()
	}

	private func cancel() {
		dismiss()
	}

}

struct NewTireView_Previews: PreviewProvider {

    static var previews: some View {
		AddTireView()
			.preferredColorScheme(.dark)
    }
}
