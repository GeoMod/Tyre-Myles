//
//  DateMilageView.swift
//  Tyre Myles
//
//  Created by Daniel O'Leary on 10/19/21.
//

import SwiftUI

struct DateMilageView: View {

	@State private var installDate = Date()

	@State private var savedInstallDate = ""
	@State private var savedRemovalDate = ""

	@State private var installMilage = ""
	@State private var removalMilage = ""
	@State private var totalMilage = "0"

	@State private var isPresentingDateSheet = false
	@State private var isPresendingMilageSheet = false

	var body: some View {
		ZStack {
			Color("Background").ignoresSafeArea()
			VStack {

				HStack {
					VStack (alignment: .center, spacing: 5) {
						Text("Install Date")
						TextField("Install Date", text: $savedInstallDate, prompt: Text("Make Selection"))
							.onTapGesture {
								isPresentingDateSheet.toggle()
							}
							.textFieldStyle(.roundedBorder)
					}.padding(.bottom)

					VStack(alignment: .center, spacing: 5) {
						Text("Removal Date")
						TextField("Removal Date", text: $savedRemovalDate, prompt: Text("Make Selection"))
							.textFieldStyle(.roundedBorder)
					}.padding(.bottom)
				}

				HStack {
					VStack(alignment: .center, spacing: 5) {
						Text("Install Milage")
						TextField("Install Milage", text: $installMilage, prompt: Text("Make Selection"))
							.textFieldStyle(.roundedBorder)
							.foregroundColor(.black)
							.onTapGesture {
								isPresendingMilageSheet.toggle()
							}
					}

					VStack(alignment: .center, spacing: 5) {
						Text("Removal Milage")
						TextField("Removal Milage", text: $removalMilage, prompt: Text("Make Selection"))
							.foregroundColor(.black)
							.textFieldStyle(.roundedBorder)
							.onTapGesture {
								isPresendingMilageSheet.toggle()
							}
					}
				}

				Text("Total Tyre Myles")
					.bold()
					.padding()
				Text("\(totalMilage)")
					.bold()
			}
			.font(.title3)
			.padding([.leading, .trailing])
			.foregroundColor(.white)

		}
		.sheet(isPresented: $isPresentingDateSheet) {
			print("date picker was dismissed")
		} content: {
			DatePicker("Date", selection: $installDate, displayedComponents: .date)
				.labelsHidden()
		}

		.sheet(isPresented: $isPresendingMilageSheet) {
			// do nothing if dismissed manually
		} content: {
//			MilageSheet(installMilage: $installMilage, removalMilage: $removalMilage, totalMilage: $totalMilage)
			MilageSheetView(installMilage: $installMilage, removalMilage: $removalMilage, totalMilage: $totalMilage)
		}

	}

}

//struct MilageSheet: View {
//
//	@Environment(\.dismiss) var dismiss
//
//	@Binding var installMilage: String
//	@Binding var removalMilage: String
//	@Binding var totalMilage: String
//
//	var body: some View {
//		VStack {
//			Text("Enter Milage Values")
//				.font(.headline)
//			Spacer()
//			Group {
//				TextField("Install Milage", text: $installMilage, prompt: Text("Installation Milage"))
//				TextField("Removal Milage", text: $removalMilage, prompt: Text("Removal Milage"))
//			}
//			.textFieldStyle(.roundedBorder)
//
//			HStack {
//				Button(role: .cancel) {
//					dismiss()
//				} label: {
//					Text("Cancel")
//						.foregroundColor(.red)
//				}.buttonStyle(.automatic)
//
//				Button {
//					calculateTotalMilesFrom(install: installMilage, to: removalMilage)
//				} label: {
//					Text("Save")
//				}.buttonStyle(.borderedProminent)
//
//			}
//
//			Spacer()
//		}
//	}
//
//	private func calculateTotalMilesFrom(install: String, to removal: String) {
//		var result = 0
//
//		guard let installMilageInt = Int(install) else { return }
//		guard let removalMilageInt = Int(removal) else { return }
//
//		result = removalMilageInt - installMilageInt
//
//		totalMilage = String(result)
//
//		dismiss()
//	}
//
//}



struct DateMilageView_Previews: PreviewProvider {

    static var previews: some View {
        DateMilageView()
    }
}
