//
//  DateSheetView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI
import CoreData

struct EditTireView: View {
	@Environment(\.dismiss) var dismiss
	
	@EnvironmentObject var model: CoreDataModel

	@State private var installDate = Date()
	@State private var removalDate = Date()

	@State private var name = ""
	@State private var installMilage: Double = 0
	@State private var removalMilage: Double = 0
	@State private var seasonType: SeasonType = .allSeason
	@State private var tireStatus: TireStatus = .inStorage

	@FocusState private var fieldIsFocused: Bool

	let currentTire: TireEntity

	// To determine whether mileage values have been changed.
	// If so, used in updating total tire mileage when in storage.
	var previousInstallMileage: Double
	var previousRemovalMilage: Double

	var previousTotal: Double {
		return previousRemovalMilage - previousInstallMileage
	}


	var body: some View {
		ScrollView {

			VStack {
				Text("Edit Tyre")
					.font(.largeTitle)
				TextField(currentTire.name ?? "Name", text: $name, prompt: Text("Name"))
					.textFieldStyle(.roundedBorder)
				Picker("Season", selection: $seasonType) {
					Text("Summer")
						.tag(SeasonType.summer)
					Text("All Season")
						.tag(SeasonType.allSeason)
					Text("Winter")
						.tag(SeasonType.winter)
				}
				.padding([.leading, .trailing])
				.pickerStyle(.segmented)

				Text("Enter Date Values")
					.font(.headline)
					.padding()
				DatePicker("Install Date", selection: $installDate, displayedComponents: .date)

				Picker("Wheel Status", selection: $tireStatus) {
					Text("On Vehicle").tag(TireStatus.onVehicle)
					Text("In Storage").tag(TireStatus.inStorage)
				}.pickerStyle(.segmented)
					.padding(.vertical)

				DatePicker("Removal Date", selection: $removalDate, in: installDate..., displayedComponents: .date)
					.opacity(tireStatus == .onVehicle ? 0.25 : 1.0)
					.disabled(tireStatus == .onVehicle)

				Text("Enter Mileage Values")
					.font(.headline)
					.padding()

				Group {
					TextField("Installation Mileage", value: $installMilage, format: .number)
					TextField("Removal Mileage", value: $removalMilage, format: .number)
					Text("Prev Total: \(previousTotal)")
				}
				.keyboardType(.numberPad)
				.textFieldStyle(.roundedBorder)


				HStack {
					Button(role: .cancel) {
						dismiss()
					} label: {
						Text("Cancel")
							.foregroundColor(.red)
					}.buttonStyle(.automatic)

					Button {
						saveEdit()
					} label: {
						Text("Save")
							.foregroundColor(.white)
					}
					.buttonStyle(.borderedProminent)
					.disabled(removalMilage == 0 && tireStatus == .inStorage)
					// Disabled to prevent poor UX logic.
					.padding()
					.alert("Mileage Entry Error", isPresented: $model.isShowingAlert) {
						Button(role: .cancel) {
							removalMilage = 0
						} label: {
							Text("OK")
						}
					} message: {
						Text(ErrorMessage.negativeNumber)
					}
				}

			}
			.padding()
			.onAppear {
				loadInitialValues()
			}

		} // End ScrollView

	}

	private func loadInitialValues() {
		guard let loadedName = currentTire.name else { return }
		guard let loadedInstallDate = currentTire.installDate else { return }
		guard let loadedRemovalDate = currentTire.removalDate else { return }
		guard let loadedTireSeason = SeasonType(rawValue: currentTire.seasonType!) else { return }
		let loadedInstallMilage = currentTire.installMiles
		let loadedRemovalMilage = currentTire.removalMiles

		name = loadedName
		seasonType = loadedTireSeason
		tireStatus = loadingTire(status: currentTire.isInStorage)
		installDate = loadedInstallDate
		removalDate = loadedRemovalDate
		installMilage = loadedInstallMilage
		removalMilage = loadedRemovalMilage
	}



	private func saveEdit() {
		currentTire.name = name
		currentTire.seasonType = seasonType.rawValue
		currentTire.isInStorage = editingTire(status: tireStatus)
		currentTire.installDate = installDate
		currentTire.removalDate = removalDate
		currentTire.installMiles = installMilage
		currentTire.removalMiles = removalMilage

		if mileageDidChange() {
			model.update(tire: currentTire)
		}
		// Dismiss View
		dismiss()
	}

	private func mileageDidChange() -> Bool {
		if previousInstallMileage == installMilage && previousRemovalMilage == removalMilage {
			return false
		} else {
			return true
		}
	}

	private func loadingTire(status: Bool) -> TireStatus {
		// To set value of Picker when loading Edit View.
		switch status {
			case true:
				return .inStorage
			case false:
				return .onVehicle
		}
	}

	private func editingTire(status: TireStatus) -> Bool {
		switch status {
			case .onVehicle:
				return false
			case .inStorage:
				return true
		}
	}



}

#if DEBUG
struct EditTireView_Previews: PreviewProvider {
    static var previews: some View {
		Text("Test View")
    }
}
#endif
